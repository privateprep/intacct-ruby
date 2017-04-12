require 'nokogiri'

require 'functions/project_function_examples'

require 'intacct_ruby/functions/update_project'

describe IntacctRuby::Functions::UpdateProject do
  function_xml = generate_function_xml(described_class, project_attributes)

  it_behaves_like 'a project function', 'update_project', function_xml

  it 'should have a controlid that describes the action' do
    expect(control_id_from(function_xml))
      .to include "update_project_#{project_attributes[:projectid]}"
  end

  it 'sends projectid as key in function header' do
    attributes = project_attributes

    expected_value = attributes[:projectid]
    parameter = function_xml.xpath('/function/update_project').first

    expect(parameter.attributes['key'].value).to eq expected_value
  end
end
