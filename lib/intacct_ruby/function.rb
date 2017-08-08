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

    def initialize(function_type, object_type, arguments = {})
      @function_type = function_type.to_s
      @object_type = object_type.to_s
      @arguments = arguments

      validate_type!
    end

    def to_xml
      xml = Builder::XmlMarkup.new

      xml.function controlid: controlid do
        xml.tag!(@function_type) do
          xml.tag!(@object_type.upcase) do
            xml << argument_xml(@arguments)
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

    def argument_xml(arguments_to_convert)
      xml = Builder::XmlMarkup.new

      arguments_to_convert.each do |key, value|
        argument_key = key.to_s.upcase

        xml.tag!(argument_key) do
          xml << argument_value_as_xml(value)
        end
      end

      xml.target!
    end

    def argument_value_as_xml(value)
      case value
      when Hash
        argument_xml(value) # recursive case
      when Array
        argument_value_list_xml(value) # recursive case
      else
        value.to_s # end case
      end
    end

    def argument_value_list_xml(array_of_hashes)
      xml = Builder::XmlMarkup.new

      array_of_hashes.each do |argument_hash|
        xml << argument_xml(argument_hash)
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
