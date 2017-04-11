require 'builder'

module IntacctRuby
  module Functions
    # Creates the basic structure for all functions.
    # Meant to be an interface: this should not be implemented on its own.
    class BaseFunction
      def initialize(controlid)
        @xml = Builder::XmlMarkup.new
        @controlid = controlid
      end

      def to_xml
        @xml.function controlid: @controlid do
          yield(@xml)
        end

        # converts xml to string
        @xml.target!
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
