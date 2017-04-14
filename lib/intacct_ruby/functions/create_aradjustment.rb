require 'intacct_ruby/functions/base_function'
require 'intacct_ruby/helpers/date_helper'

module IntacctRuby
  module Functions
    # creates ar adjustment instance in Intacct
    class CreateARAdjustment < BaseFunction
      include DateHelper

      def initialize(attrs = {})
        super "create_aradjustment (Customer \##{attrs[:customerid]}, " \
              "(#{timestamp})", attrs
      end

      def to_xml
        super do |xml|
          xml.create_aradjustment do
            xml.customerid @attrs[:customerid]

            xml << date_params(:datecreated, @attrs[:datecreated])

            xml.description @attrs[:description]

            xml.aradjustmentitems do
              xml << line_item_params(@attrs[:aradjustmentitems])
            end
          end
        end
      end

      private

      def line_item_params(adjustment_item_attrs)
        xml = Builder::XmlMarkup.new

        adjustment_item_attrs.each do |item_params|
          xml.lineitem do
            [:glaccountno, :amount, :memo, :locationid].each do |param_key|
              xml.tag!(param_key) { xml << item_params[param_key].to_s }
            end
          end
        end

        xml.target!
      end
    end
  end
end
