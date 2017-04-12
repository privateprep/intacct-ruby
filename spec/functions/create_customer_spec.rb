require 'nokogiri'

require 'functions/function_spec_helper'
require 'functions/customer_function_examples'

require 'intacct_ruby/functions/create_customer'

describe IntacctRuby::Functions::CreateCustomer do
  function_xml = generate_function_xml(described_class, customer_attributes)

  it_behaves_like 'a customer function', 'create_customer', function_xml

  it 'should have a controlid that describes the action' do
    expect(control_id_from(function_xml))
      .to eq "create_customer_#{customer_attributes[:customerid]}"
  end

  it 'sends customerid param in body' do
    param_path = "#{function_base_path('create_customer')}/customerid"
    param = function_xml.xpath(param_path)

    expected_value = customer_attributes[:customerid]

    expect(param.text).to eq(expected_value),
                          "Value of \"customerid\" did not match. " \
                          "Expected \"#{expected_value}\", got " \
                          "\"#{param.text}\""
  end
end
