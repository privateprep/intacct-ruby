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
    end
  end
end
