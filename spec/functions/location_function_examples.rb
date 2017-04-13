require 'nokogiri'

require 'functions/function_spec_helper'

def location_attributes(overrides = {})
  {
    locationid: '4',
    name: 'Some New Location',
    parentid: '123',
    startdate: { year: '2013', month: '11', day: '6' }
  }.merge(overrides)
end

shared_examples 'a location function' do |function_xml|
  include IntacctRuby::DateHelper

  let(:xml_base) { function_base_path(function_name) }

  let(:function_name) { function_name_from(function_xml) }

  it 'contains expected location params' do
    [:name, :parentid].each do |parameter_key|
      parameter = function_xml.xpath("#{xml_base}/#{parameter_key}")
      expected_value = location_attributes[parameter_key]

      expect(parameter.text)
        .to eq(expected_value),
            "Value of #{parameter_key} did not match. " \
            "Expected \"#{expected_value}\", got \"#{parameter.text}\""
    end
  end
end
