require 'nokogiri'

shared_examples 'a function' do |function_xml, controlid_fragment|
  it 'has a descriptive controlid' do
    function_controlid = function_xml.xpath('/function')
                                     .first
                                     .attributes['controlid']

    expect(function_controlid.text).to include(controlid_fragment)
  end
end
