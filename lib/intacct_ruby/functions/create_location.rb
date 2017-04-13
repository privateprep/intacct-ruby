require 'intacct_ruby/functions/location_base_function'

module IntacctRuby
  module Functions
    # Function that creates a location instance in Intacct
    class CreateLocation < LocationBaseFunction
      def initialize(attrs = {})
        super("create_location_#{attrs[:locationid]}", attrs)
      end

      def to_xml
        super do |xml|
          xml.create_location do
            xml.locationid @attrs[:locationid]
            xml << location_params
          end
        end
      end
    end
  end
end
