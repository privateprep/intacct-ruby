require 'nokogiri'

require 'intacct_ruby/helpers/contacts_helper'

require 'functions/function_spec_helper'

def employee_attributes(overrides = {})
  { employeeid: '1',
    first_name: 'Doug',
    last_name: 'Funny',
    type: 'Student',
    email1: 'doug@funny.com',
    status: 'active',
    locationid: '123',
    supervisorid: '1234',
    startdate: { year: '2013', month: '11', day: '6' }
  }.merge(overrides)
end

shared_examples 'an employee function' do |function_name, function_xml|
  include IntacctRuby::ContactsHelper
  include IntacctRuby::DateHelper

  let(:xml_base) { function_base_path(function_name) }

  it 'contains expected employee params' do
    [:locationid, :supervisorid, :status].each do |parameter_key|
      parameter = function_xml.xpath("#{xml_base}/#{parameter_key}")
      expected_value = employee_attributes[parameter_key]

      expect(parameter.text)
        .to eq(expected_value),
            "Value of #{parameter_key} did not match. " \
            "Expected \"#{expected_value}\", got \"#{parameter.text}\""
    end
  end

  it 'contains expected contactinfo for employee' do
    contact_params = function_xml.xpath("#{xml_base}/personalinfo/contact")

    expected_params = Nokogiri::XML contact_params(
      employee_attributes,
      employee_attributes[:employeeid],
      'Employee'
    )

    expect(contact_params.to_s)
      .to eq expected_params.xpath('contact').to_s
  end

  it 'contains expected startdate for employee' do
    startdate_params = function_xml.xpath("#{xml_base}/startdate")

    expected_params = Nokogiri::XML date_params(
      :startdate,
      employee_attributes[:startdate]
    )

    expect(startdate_params.to_s)
      .to eq expected_params.xpath('startdate').to_s
  end
end
