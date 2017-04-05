require 'intacct_ruby/functions/base_function'
require 'spec_helper'
require 'nokogiri'

include IntacctRuby::Functions

describe BaseFunction do
  let(:controlid)  { 'some controlid' }
  let(:function)   { BaseFunction.new(controlid) }
  let(:xml_string) { function.to_xml { 'function_body' } }

  it 'can be converted to an XML string' do
    expect(xml_string).to be_a String

    # check that XML is valid
    expect { Nokogiri::XML(xml_string, &:strict) }.not_to raise_error
  end

  it 'contains shows a control id' do
    request_controlid = Nokogiri::XML(xml_string).children
                                                 .first
                                                 .attributes['controlid']

    expect(request_controlid.value).to eq controlid
  end
end
