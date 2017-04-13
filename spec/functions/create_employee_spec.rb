require 'nokogiri'

require 'intacct_ruby/functions/create_employee'

require 'functions/employee_function_examples'

describe IntacctRuby::Functions::CreateEmployee do
  function_xml = generate_function_xml(described_class, employee_attributes)

  it_behaves_like 'an employee function', 'create_employee', function_xml

  it 'has a descriptive controlid' do
    controlid = function_xml.xpath('/function')
                            .first
                            .attributes['controlid']

    expect(controlid.text)
      .to include("create_employee_#{employee_attributes[:id]}")
  end

  it 'sends employeeid in function body' do
    employeeid = function_xml.xpath('/function/create_employee/employeeid').text

    expect(employeeid).to eq employee_attributes[:employeeid]
  end
end
