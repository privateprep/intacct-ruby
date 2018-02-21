require 'builder'
require 'intacct_ruby/exceptions/unknown_function_type'

module IntacctRuby
  # a function to be sent to Intacct. Defined by a function type (e.g. :create),
  # an object type, (e.g. :customer), and arguments.
  class Function
    ALLOWED_TYPES = %w(
      readByQuery
      read
      readByName
      create
      update
      delete
    ).freeze

    CU_TYPES = %w(create update).freeze

    LEGACY_API = { 'sodocument' => 'sotransaction' }.freeze

    def initialize(function_type, object_type, arguments = {})
      @function_type = function_type.to_s
      @object_type = object_type.to_s
      @arguments = arguments

      validate_type!
    end

    def to_xml
      xml = Builder::XmlMarkup.new

      xml.function controlid: controlid do
        xml.tag!(functionid) do
          if legacy_end_point? || CU_TYPES.exclude?(@function_type)
            xml << argument_xml(@arguments, to_case: :downcase)
          else
            xml.tag!(@object_type.upcase) do
              xml << argument_xml(@arguments)
            end
          end
        end
      end

      xml.target!
    end

    private

    def timestamp
      @timestamp ||= Time.now.utc.to_s
    end

    def controlid
      "#{@function_type}-#{@object_type}-#{timestamp}"
    end

    def functionid
      translation = LEGACY_API[@object_type.downcase] || @object_type.downcase
      legacy_end_point? ? "#{@function_type}_#{translation}" : @function_type
    end

    def legacy_end_point?
      LEGACY_API.keys.any? { |s| s.casecmp(@object_type).zero? } && CU_TYPES.include?(@function_type)
    end

    def argument_xml(arguments_to_convert, options = {})
      default_options = { to_case: :upcase }
      options = options.reverse_merge!(default_options)

      xml = Builder::XmlMarkup.new

      arguments_to_convert.each do |key, value|
        argument_key = case options[:to_case]
                       when :upcase
                         key.to_s.upcase
                       when :downcase
                         key.to_s.downcase
                       else
                         key.to_s
                       end

        xml.tag!(argument_key) do
          xml << argument_value_as_xml(value, options)
        end
      end

      xml.target!
    end

    def argument_value_as_xml(value, options = {})
      case value
      when Hash
        argument_xml(value, options) # recursive case
      when Array
        argument_value_list_xml(value, options) # recursive case
      else
        value.to_s # end case
      end
    end

    def argument_value_list_xml(array_of_hashes, options = {})
      xml = Builder::XmlMarkup.new

      array_of_hashes.each do |argument_hash|
        xml << argument_xml(argument_hash, options)
      end

      xml.target!
    end

    def validate_type!
      unless ALLOWED_TYPES.include?(@function_type)
        raise Exceptions::UnknownFunctionType,
              "Type #{@object_type} not recognized. Function Type must be " \
              "one of #{ALLOWED_TYPES}."
      end
    end
  end
end
