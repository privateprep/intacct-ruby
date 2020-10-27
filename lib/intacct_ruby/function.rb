require 'builder'
require 'intacct_ruby/exceptions/unknown_function_type'

module IntacctRuby
  # a function to be sent to Intacct. Defined by a function type (e.g. :create),
  # an object type, (e.g. :customer), and parameters.
  class Function
    ALLOWED_TYPES = %w(
      readByQuery
      read
      readByName
      readMore
      create
      update
      delete
      getAPISession
      create_potransaction
      create_supdoc
    ).freeze

    CU_TYPES = %w(create update).freeze

    def initialize(function_type, object_type: nil, parameters: )
      @function_type = function_type.to_s
      @object_type = object_type.to_s
      @parameters = parameters

      validate_type!
    end

    def to_xml
      xml = Builder::XmlMarkup.new

      xml.function controlid: controlid do
        xml.tag!(@function_type) do
          if CU_TYPES.include?(@function_type)
            xml.tag!(@object_type) do
              xml << parameter_xml(@parameters)
            end
          else
            xml << parameter_xml(@parameters)
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

    def parameter_xml(parameters_to_convert)
      xml = Builder::XmlMarkup.new

      parameters_to_convert.each do |key, value|
        parameter_key = key.to_s

        xml.tag!(parameter_key) do
          xml << parameter_value_as_xml(value)
        end
      end

      xml.target!
    end

    def parameter_value_as_xml(value)
      case value
      when Hash
        parameter_xml(value) # recursive case
      when Array
        parameter_value_list_xml(value) # recursive case
      else
        value.to_s.encode(xml: :text) # end case
      end
    end

    def parameter_value_list_xml(array_of_hashes)
      xml = Builder::XmlMarkup.new

      array_of_hashes.each do |parameter_hash|
        xml << parameter_xml(parameter_hash)
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
