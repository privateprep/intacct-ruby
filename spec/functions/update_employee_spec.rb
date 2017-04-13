require 'intacct_ruby/functions/update_employee'

require 'functions/employee_function_examples'
require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/update_function_examples'

describe IntacctRuby::Functions::UpdateEmployee do
  function_xml = generate_function_xml(described_class, employee_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "update_employee_#{employee_attributes[:employeeid]}"

  it_behaves_like 'an update function',
                  function_xml,
                  :employeeid,
                  employee_attributes[:employeeid]

  it_behaves_like 'an employee function', function_xml
end
