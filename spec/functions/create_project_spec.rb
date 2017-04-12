require 'nokogiri'

require 'functions/function_spec_helper'
require 'functions/project_function_examples'

require 'intacct_ruby/functions/create_project'

describe IntacctRuby::Functions::CreateProject do
  function_xml = generate_function_xml(described_class, project_attributes)
  it_behaves_like 'a project function', 'create_project', function_xml
end
