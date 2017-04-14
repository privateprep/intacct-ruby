require 'intacct_ruby/functions/create_aradjustment'
require 'intacct_ruby/helpers/date_helper'

require 'functions/function_spec_helper'
require 'functions/function_examples'

def line_item_params
  @line_item_params ||= (1..5).to_a.map do |i|
    {
      glaccountno: "glaccountno #{i}",
      amount: "amount #{i}",
      memo: "description #{i}",
      locationid: "locationid #{i}"
    }
  end
end

def aradjustment_attributes(overrides = {})
  {
    customerid: '1',
    datecreated: { year: '2016', month: '3', day: '8' },
    description: 'some description',
    aradjustmentitems: line_item_params
  }.merge(overrides)
end

describe IntacctRuby::Functions::CreateARAdjustment do
  include IntacctRuby::DateHelper

  function_xml = generate_function_xml(described_class, aradjustment_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  'create_aradjustment (Customer ' \
                  "\##{aradjustment_attributes[:customerid]},"

  let(:xml_base) { function_base_path(function_name) }

  let(:function_name) { function_name_from(function_xml) }

  it 'contains expected customer params' do
    [:customerid, :description].each do |parameter_key|
      parameter = function_xml.xpath("#{xml_base}/#{parameter_key}")
      expected_value = aradjustment_attributes[parameter_key]

      expect(parameter.text)
        .to eq(expected_value),
            "Value of #{parameter_key} did not match. " \
            "Expected \"#{expected_value}\", got \"#{parameter.text}\""
    end
  end

  it 'contains expected datecreated attributes' do
    parameter = function_xml.xpath("#{xml_base}/datecreated")
    expected_params = Nokogiri::XML date_params(
      :datecreated,
      aradjustment_attributes[:datecreated]
    )

    expect(parameter.to_s)
      .to eq(expected_params.xpath('/datecreated').to_s)
  end

  it 'contains expected line item params' do
    line_items_base = function_xml.xpath("#{xml_base}/aradjustmentitems")
    line_item_params.each_with_index do |expected_params, i|
      # `i + 1` because xpath indexing starts at 1, but ruby array indexing
      # starts at zero
      actual_param = line_items_base.xpath("lineitem[#{i + 1}]")

      expected_params.each do |expected_param_key, expected_param_value|
        expect(actual_param.xpath(expected_param_key.to_s).text)
          .to eq(expected_param_value)
      end
    end
  end
end
