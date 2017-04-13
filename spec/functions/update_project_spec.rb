require 'intacct_ruby/functions/update_project'

require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/project_function_examples'
require 'functions/update_function_examples'

describe IntacctRuby::Functions::UpdateProject do
  function_xml = generate_function_xml(described_class, project_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "update_project_#{project_attributes[:projectid]}"

  it_behaves_like 'an update function',
                  function_xml,
                  :key,
                  project_attributes[:projectid]

  # even though it's not one, it "behaves_like" a creation function in that it
  # also carries project ID inside of the function body. Why? Because Intacct.
  it_behaves_like 'a creation function',
                  function_xml,
                  :projectid,
                  project_attributes[:projectid]

  it_behaves_like 'a project function', function_xml
end
