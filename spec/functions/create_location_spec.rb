require 'intacct_ruby/functions/create_location'

require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/location_function_examples'
require 'functions/creation_function_examples'

describe IntacctRuby::Functions::CreateLocation do
  function_xml = generate_function_xml(described_class, location_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "create_location_#{location_attributes[:locationid]}"

  it_behaves_like 'a creation function',
                  function_xml,
                  :locationid,
                  location_attributes[:locationid]

  it_behaves_like 'a location function', function_xml
end
