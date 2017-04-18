require 'builder'

module IntacctRuby
  module Functions
    # Creates the basic structure for all functions.
    # Meant to be an interface: this should not be implemented on its own.
    class BaseFunction
      def initialize(controlid, attrs = {})
        @controlid = controlid
        @attrs = attrs

        @xml = Builder::XmlMarkup.new
      end

      def to_xml
        @to_xml ||= begin
          @xml.function controlid: @controlid do
            yield(@xml)
          end

          # converts xml to string
          @xml.target!
        end
      end

      private

      def timestamp
        @timestamp ||= Time.now.utc.to_s
      end

      def custom_field_params(custom_fields)
        xml = Builder::XmlMarkup.new

        xml.customfields do
          custom_fields.each do |name, value|
            xml.customfield do
              xml.customfieldname   name.to_s
              xml.customfieldvalue  value.to_s
            end
          end
        end

        xml.target!
      end
    end
  end
end
