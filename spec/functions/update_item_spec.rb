require 'intacct_ruby/functions/update_item'

require 'functions/item_function_examples'
require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/update_function_examples'

describe IntacctRuby::Functions::UpdateItem do
  function_xml = generate_function_xml(described_class, item_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "update_item_#{item_attributes[:itemid]}"

  it_behaves_like 'an update function',
                  function_xml,
                  :itemid,
                  item_attributes[:itemid]

  it_behaves_like 'a item function', function_xml
end
