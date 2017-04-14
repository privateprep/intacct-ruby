require 'intacct_ruby/functions/item_base_function'

module IntacctRuby
  module Functions
    # creates an item instance in Intacct
    class CreateItem < ItemBaseFunction
      def initialize(attrs = {})
        super "create_item_#{attrs[:itemid]}", attrs
      end

      def to_xml
        super do |xml|
          xml.create_item do
            xml.itemid @attrs[:itemid]
            xml << item_params
          end
        end
      end
    end
  end
end
