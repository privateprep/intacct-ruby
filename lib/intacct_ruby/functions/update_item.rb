require 'intacct_ruby/functions/item_base_function'

module IntacctRuby
  module Functions
    # updates item instance in Intacct
    class UpdateItem < ItemBaseFunction
      def initialize(attrs = {})
        super "update_item_#{attrs[:itemid]} (#{timestamp})", attrs
      end

      def to_xml
        super do |xml|
          xml.update_item itemid: @attrs[:itemid] do
            xml << item_params
          end
        end
      end
    end
  end
end
