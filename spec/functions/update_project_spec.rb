require 'nokogiri'

require 'functions/project_function_examples'

require 'intacct_ruby/functions/update_project'

describe IntacctRuby::Functions::UpdateProject do
  it_behaves_like 'a project function', 'update_project', project_attributes

  it 'sends projectid as key in function header' do
    attributes = project_attributes
    xml_output = generate_function_xml(described_class, attributes)

    expected_value = attributes[:projectid]
    parameter = xml_output.xpath('/function/update_project').first

    expect(parameter.attributes['key'].value).to eq expected_value
  end
end
