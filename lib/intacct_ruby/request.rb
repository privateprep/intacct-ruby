require 'builder'
require 'figaro'

require 'intacct_ruby/api'
require 'intacct_ruby/response'

module IntacctRuby
  # An outgoing request to the Intacct API. Can have multiple functions.
  # Complete with send method that gets (and wraps) response from Intacct.
  class Request
    DEFAULTS = {
      uniqueid: false,
      dtdversion: 3.0,
      includewhitespace: false,
      transaction: true
    }.freeze

    def initialize(*args)
      @opts = DEFAULTS.dup

      # `args` should be a list of Intacct::Function objects, with the last
      # argument optionally providing overrides to request defaults
      @opts.merge!(args.pop) if args.last.is_a? Hash

      # If a hash is provided + popped, the remaining attrs are functions
      @functions = args
    end

    def to_xml
      @request = Builder::XmlMarkup.new

      request.instruct!
      request.request do
        control_block
        operation_block
      end
    end

    def send(api = nil)
      api ||= Api.new

      Response.new api.send(self)
    end

    private

    attr_reader :request, :functions

    def timestamp
      @timestamp ||= Time.now.utc.to_s
    end

    def control_block
      request.control do
        request.senderid Figaro.env.INTACCT_SENDER_ID
        request.password Figaro.env.INTACCT_SENDER_PW

        # As recommended by Intacct API reference. This ID should be unique
        # to the call: it's used to associate a response with a request.
        request.controlid          timestamp
        request.uniqueid           @opts[:uniqueid]
        request.dtdversion         @opts[:dtdversion]
        request.includewhitespace  @opts[:includewhitespace]
      end
    end

    def authentication_block
      request.authentication do
        request.login do
          request.userid    Figaro.env.INTACCT_USER_ID
          request.companyid Figaro.env.INTACCT_COMPANY_ID
          request.password  Figaro.env.INTACCT_USER_PW
        end
      end
    end

    def operation_block
      request.operation transaction: @opts[:transaction] do
        authentication_block
        request.content do
          functions.each do |function|
            request << function.to_xml
          end
        end
      end
    end
  end
end
