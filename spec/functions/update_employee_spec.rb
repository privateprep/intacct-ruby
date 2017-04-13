require 'nokogiri'

require 'intacct_ruby/functions/update_employee'

require 'functions/employee_function_examples'

describe IntacctRuby::Functions::UpdateEmployee do
  function_xml = Nokogiri::XML described_class.new(employee_attributes).to_xml

  it_behaves_like 'an employee function', 'update_employee', function_xml

  it 'has a descriptive controlid' do
    controlid = function_xml.xpath('/function')
                            .first
                            .attributes['controlid']

    expect(controlid.text)
      .to include("update_employee_#{employee_attributes[:id]}")
  end

  it 'sends employeeid in function header' do
    parameter = function_xml.xpath('/function/update_employee')
                            .first
                            .attributes['employeeid']

    expect(parameter.text).to eq employee_attributes[:employeeid]
  end
end
