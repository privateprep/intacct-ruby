require 'nokogiri'

require 'intacct_ruby/helpers/date_helper'

describe IntacctRuby::DateHelper do
  include described_class

  let(:attrs) do
    {
      year: '2017',
      month: '4',
      day: '13'
    }
  end

  let(:block_name) { :some_date_name }

  let(:output) do
    Nokogiri::XML date_params(block_name, attrs)
  end

  it 'creates an XML block with appropriate name' do
    expect(output.children.first.name).to eq block_name.to_s
  end

  it 'creates an XML block with appropriate attributes' do
    attrs.each do |key, expected_value|
      parameter = output.xpath("/#{block_name}/#{key}")
      expect(parameter.text).to eq expected_value
    end
  end
end
