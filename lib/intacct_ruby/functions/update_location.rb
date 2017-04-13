require 'intacct_ruby/functions/location_base_function'

module IntacctRuby
  module Functions
    # used to update location instances in Intacct
    class UpdateLocation < LocationBaseFunction
      def initialize(attrs = {})
        super("update_location_#{attrs[:locationid]} (#{timestamp})", attrs)
      end

      def to_xml
        super do |xml|
          xml.update_location locationid: @attrs[:locationid] do
            xml << location_params
          end
        end
      end
    end
  end
end
