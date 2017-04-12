require 'nokogiri'

require 'intacct_ruby/functions/create_customer'
require 'intacct_ruby/helpers/contacts_helper'

describe IntacctRuby::Functions::CreateCustomer do
  include IntacctRuby::ContactsHelper

  describe :to_xml do
    let(:attrs) do
      {
        customerid: '1',
        first_name: 'Han',
        last_name: 'Solo',
        type: 'Person',
        email1: 'han@solo.com',
        status: 'active'
      }
    end

    let(:output) do
      request = IntacctRuby::Functions::CreateCustomer.new(attrs)
      Nokogiri::XML(request.to_xml)
    end

    let(:xml_base) { '/function/create_customer' }

    it 'should have a controlid that describes the action' do
      parameter = output.xpath('/function')
                        .first
                        .attributes['controlid']

      expect(parameter.value).to eq "create_customer_#{attrs[:customerid]}"
    end

    it 'contains expected customer params' do
      {
        customerid: attrs[:customerid],
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
      params = contact_params(attrs, attrs[:customerid], 'Customer')

      expected_value = Nokogiri::XML(params)
                               .xpath('contact')
                               .to_s

      actual_value = output.xpath("#{xml_base}/contactinfo/contact")
                           .to_s

      expect(actual_value).to eq expected_value
    end
  end
end
