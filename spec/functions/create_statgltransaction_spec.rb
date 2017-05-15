require 'intacct_ruby/functions/create_statgltransaction'

require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/gltransaction_function_examples'

describe IntacctRuby::Functions::CreateStatGLTransaction do
  function_attributes = generate_transaction_attributes(:statgl)

  function_xml = generate_function_xml(
    described_class,
    function_attributes
  )

  it_behaves_like 'a function',
                  function_xml,
                  'create_statgltransaction ' \
                  "(#{function_attributes[:description]}"

  it_behaves_like 'a gltransaction function',
                  'create_statgltransaction',
                  :statgl,
                  function_attributes,
                  function_xml
end
