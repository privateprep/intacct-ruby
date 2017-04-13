require 'nokogiri'

shared_examples 'an update function' do |function_xml, id_key, id_value|
  # A short legend for these passed attributes:
  # => xml: the xml output of the create function
  # => id_key: the XML key under which the id of the object to create is found
  # => id_value: what it sounds like
  let(:function_name) { function_xml.xpath('/function').children.first.name }

  it 'sends object id in function header' do
    id_param = function_xml.xpath("/function/#{function_name}")
                           .first
                           .attributes[id_key.to_s]

    expect(id_param.value).to eq id_value
  end
end
