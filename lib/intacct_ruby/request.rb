require 'builder'

require 'intacct_ruby/api'
require 'intacct_ruby/response'
require 'intacct_ruby/function'

require 'intacct_ruby/exceptions/insufficient_credentials_exception'
require 'intacct_ruby/exceptions/empty_request_exception'

module IntacctRuby
  # An outgoing request to the Intacct API. Can have multiple functions.
  # Complete with send method that gets (and wraps) response from Intacct.
  class Request
    attr_reader :functions

    DEFAULTS = {
      uniqueid: false,
      dtdversion: 3.0,
      includewhitespace: false,
      transaction: true
    }.freeze

    REQUIRED_AUTHENTICATION_KEYS = [
      :senderid,
      :sender_password,
      :userid,
      :companyid,
      :user_password
    ].freeze

    REQUIRED_SESSION_AUTHENTICATION_KEYS = [
      :sessionid
    ].freeze


    def initialize(*functions, request_params)
      # request_params should contain all req'd authentication information. If
      # not, an error will be thrown on #send
      @opts = DEFAULTS.dup.merge request_params

      # If a hash is provided + popped, the remaining attrs are functions
      @functions = functions
    end

    def to_xml
      @to_xml ||= begin
        @request = Builder::XmlMarkup.new

        @request.instruct!
        @request.request do
          control_block
          operation_block
        end
      end
    end

    def send!(opts = {})
      api = opts[:api] || Api.new

      validate_keys!
      validate_functions!

      Response.new api.send_request(self)
    end

    private

    def method_missing(method_name, *arguments, &block)
      super unless Function::ALLOWED_TYPES.include? method_name.to_s

      # object_type must be the first argument in arguments
      @functions << Function.new(method_name, arguments.shift, *arguments)
    end

    def respond_to_missing?(method_name, include_private = false)
      Function::ALLOWED_TYPES.include?(method_name) || super
    end

    def validate_functions!
      unless functions.any?
        raise Exceptions::EmptyRequestException,
              'a successful request must contain at least one function'
      end
    end

    def validate_keys!
      required_authentication_keys_for_scope = if @opts.keys.include?(:sessionid)
                                                 REQUIRED_SESSION_AUTHENTICATION_KEYS
                                               else
                                                 REQUIRED_AUTHENTICATION_KEYS
                                               end

      missing_keys = required_authentication_keys_for_scope - @opts.keys

      unless missing_keys.empty?
        missing_keys.map! { |s| ":#{s}" } # so they appear as symbols in output

        raise Exceptions::InsufficientCredentialsException,
              "[#{missing_keys.join(', ')}] required for a valid request. "
              'All authentication-related keys should be provided on ' \
              'instantiation in IntacctRuby::Request#new'
      end
    end

    def timestamp
      @timestamp ||= Time.now.utc.to_s
    end

    def control_block
      @request.control do
        @request.senderid @opts[:senderid]
        @request.password @opts[:sender_password]

        # As recommended by Intacct API reference. This ID should be unique
        # to the call: it's used to associate a response with a request.
        @request.controlid          timestamp
        @request.uniqueid           @opts[:uniqueid]
        @request.dtdversion         @opts[:dtdversion]
        @request.includewhitespace  @opts[:includewhitespace]
      end
    end

    def authentication_block
      @request.authentication do
        if @opts[:sessionid]
          @request.sessionid @opts[:sessionid]
        else
          @request.login do
            @request.userid     @opts[:userid]
            @request.companyid  @opts[:companyid]
            @request.password   @opts[:user_password]
            @request.locationid @opts[:locationid]
          end
        end
      end
    end

    def operation_block
      @request.operation transaction: @opts[:transaction] do
        authentication_block
        @request.content do
          functions.each do |function|
            @request << function.to_xml
          end
        end
      end
    end
  end
end
