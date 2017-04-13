require 'intacct_ruby/functions/create_project'

require 'functions/project_function_examples'
require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/creation_function_examples'

describe IntacctRuby::Functions::CreateProject do
  function_xml = generate_function_xml(described_class, project_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "create_project_#{project_attributes[:projectid]}"

  it_behaves_like 'a creation function',
                  function_xml,
                  :projectid,
                  project_attributes[:projectid]

  it_behaves_like 'a project function', 'create_project', function_xml
end
