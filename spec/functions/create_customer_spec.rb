require 'nokogiri'

require 'intacct_ruby/functions/create_customer'
require 'intacct_ruby/helpers/contacts_helper'

describe IntacctRuby::Functions::CreateCustomer do
  include IntacctRuby::ContactsHelper

  describe :to_xml do
    let(:attrs) do
      {
        first_name: 'Han',
        last_name: 'Solo',
        type: 'Person',
        id: '1',
        email1: 'han@solo.com',
        status: 'active'
      }
    end

    let(:output) do
      request = IntacctRuby::Functions::CreateCustomer.new(attrs)
      Nokogiri::XML(request.to_xml)
    end

    let(:xml_base) { '/function/create_customer' }

    it 'contains expected customer params' do
      {
        customerid: attrs[:id],
        name: full_name(attrs),
        status: attrs[:status]
      }.each do |parameter_key, expected_value|
        parameter = output.xpath("#{xml_base}/#{parameter_key}")
        expect(parameter.text)
          .to eq(expected_value),
              "Value of #{parameter_key} did not match. " \
              "Expected \"#{expected_value}\", got \"#{parameter.text}\""
      end
    end

    it 'contains expected contactinfo for customer' do
      expected_value = Nokogiri::XML(contact_params(attrs))
                               .xpath('contact')
                               .to_s

      actual_value = output.xpath("#{xml_base}/contactinfo/contact")
                           .to_s

      expect(actual_value).to eq expected_value
    end
  end
end
