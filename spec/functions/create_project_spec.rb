require 'nokogiri'

require 'functions/function_spec_helper'
require 'functions/project_function_examples'

require 'intacct_ruby/functions/create_project'

describe IntacctRuby::Functions::CreateProject do
  function_xml = generate_function_xml(described_class, project_attributes)

  it_behaves_like 'a project function', 'create_project', function_xml

  it 'should have a controlid that describes the action' do
    expect(control_id_from(function_xml))
      .to eq "create_project_#{project_attributes[:projectid]}"
  end

  it 'sends project param in body' do
    param_path = "#{function_base_path('create_project')}/projectid"
    param = function_xml.xpath(param_path)

    expected_value = project_attributes[:projectid]

    expect(param.text).to eq(expected_value),
                          "Value of \"project\" did not match. " \
                          "Expected \"#{expected_value}\", got " \
                          "\"#{param.text}\""
  end
end
