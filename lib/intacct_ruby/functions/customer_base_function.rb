require 'intacct_ruby/functions/base_function'
require 'intacct_ruby/helpers/contacts_helper'

module IntacctRuby
  module Functions
    # the parent for all customer-related functions. Includes methods that
    # cut down on duplicate code
    class CustomerBaseFunction < BaseFunction
      include ContactsHelper

      private

      def customer_params
        xml = Builder::XmlMarkup.new

        xml.name full_name(@attrs)
        xml.status @attrs[:status]
        xml.contactinfo do
          xml << contact_params(@attrs, @attrs[:customerid], 'Customer')
        end

        xml.target!
      end
    end
  end
end
