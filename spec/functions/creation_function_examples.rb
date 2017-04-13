require 'nokogiri'

require 'functions/function_spec_helper'

shared_examples 'a creation function' do |function_xml, id_key, id_value|
  # A short legend for these passed attributes:
  # => xml: the xml output of the create function
  # => id_key: the XML key under which the id of the object to create is found
  # => id_value: what it sounds like

  let(:function_name) { function_name_from(function_xml) }

  it 'sends object id in function body' do
    id_param = function_xml.xpath("/function/#{function_name}/#{id_key}")

    expect(id_param.text).to eq id_value
  end
end
