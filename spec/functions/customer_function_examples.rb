require 'nokogiri'
require 'intacct_ruby/helpers/contacts_helper'

def customer_attributes(overrides = {})
  {
    customerid: '1',
    first_name: 'Han',
    last_name: 'Solo',
    type: 'Person',
    email1: 'han@solo.com',
    status: 'active'
  }.merge(overrides)
end

shared_examples 'a customer function' do |function_name, function_xml|
  include IntacctRuby::ContactsHelper

  let(:xml_base) { function_base_path(function_name) }

  it 'contains expected customer params' do
    {
      name: full_name(customer_attributes),
      status: customer_attributes[:status]
    }.each do |parameter_key, expected_value|
      parameter = function_xml.xpath("#{xml_base}/#{parameter_key}")
      expect(parameter.text)
        .to eq(expected_value),
            "Value of #{parameter_key} did not match. " \
            "Expected \"#{expected_value}\", got \"#{parameter.text}\""
    end
  end

  it 'contains expected contactinfo for customer' do
    params = contact_params(
      customer_attributes,
      customer_attributes[:customerid],
      'Customer'
    )

    expected_value = Nokogiri::XML(params)
                             .xpath('contact')
                             .to_s

    actual_value = function_xml.xpath("#{xml_base}/contactinfo/contact")
                         .to_s

    expect(actual_value).to eq expected_value
  end
end
