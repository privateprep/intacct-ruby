require 'intacct_ruby/helpers/contacts_helper'
require 'intacct_ruby/functions/base_function'

module IntacctRuby
  module Functions
    # function that creates customer instance
    class CreateCustomer < BaseFunction
      include ContactsHelper

      def initialize(attrs = {})
        @attrs = attrs
        super "create_customer_#{@attrs[:id]}"
      end

      def to_xml
        super do |xml|
          xml.create_customer do
            xml.customerid @attrs[:id]
            xml.name full_name(@attrs)
            xml.status @attrs[:status]
            xml.contactinfo do
              xml << contact_params(@attrs)
            end
          end
        end
      end
    end
  end
end
