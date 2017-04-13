require 'intacct_ruby/functions/update_customer'

require 'functions/customer_function_examples'
require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/update_function_examples'

describe IntacctRuby::Functions::UpdateCustomer do
  function_xml = generate_function_xml(described_class, customer_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "update_customer_#{customer_attributes[:customerid]}"

  it_behaves_like 'an update function',
                  function_xml,
                  :customerid,
                  customer_attributes[:customerid]

  it_behaves_like 'a customer function', 'update_customer', function_xml
end
