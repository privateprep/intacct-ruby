require 'nokogiri'

require 'functions/project_function_examples'

require 'intacct_ruby/functions/create_project'

describe IntacctRuby::Functions::CreateProject do
  it_behaves_like 'a project function', 'create_project', project_attributes
end
