require 'intacct_ruby/functions/create_gltransaction'

require 'functions/function_spec_helper'
require 'functions/function_examples'

GLTRANSACTION_ATTRIBUTES = {
  journalid: 'some journalid',
  datecreated: {
    year:  'glentry2 year',
    month: 'glentry2 month',
    day:   'glentry2 day'
  },
  description: 'some description',
  gltransactionentries: [
    {
      trtype:      'glentry1 trtype',
      amount:      'glentry1 amount',
      glaccountno: 'glentry1 glaccountno',
      datecreated: {
        year:  'glentry1 year',
        month: 'glentry1 month',
        day:   'glentry1 day'
      },
      memo:       'glentry1 memo',
      locationid: 'glentry1 locationid',
      customerid: 'glentry1 customerid'
    },
    {
      trtype:      'glentry2 trtype',
      amount:      'glentry2 amount',
      glaccountno: 'glentry2 glaccountno',
      datecreated: {
        year:  'glentry2 year',
        month: 'glentry2 month',
        day:   'glentry2 day'
      },
      memo:       'glentry2 memo',
      locationid: 'glentry2 locationid',
      customerid: 'glentry2 customerid'
    }
  ]
}.freeze

describe IntacctRuby::Functions::CreateGLTransaction do
  function_xml = generate_function_xml(
    described_class,
    GLTRANSACTION_ATTRIBUTES
  )

  let(:xml_root) { 'function/create_gltransaction' }

  it_behaves_like 'a function',
                  function_xml,
                  'create_gltransaction ' \
                  "(#{GLTRANSACTION_ATTRIBUTES[:description]}"

  it 'contains expected top-level fields' do
    [:journalid, :description].each do |key|
      xml_value = function_xml.xpath("#{xml_root}/#{key}")

      expect(xml_value.text).to eq GLTRANSACTION_ATTRIBUTES[key]
    end
  end

  it 'contains expected top-level datecreated attribute' do
    date_key = :datecreated

    GLTRANSACTION_ATTRIBUTES[date_key].each do |key, expected_value|
      xml_value = function_xml.xpath("#{xml_root}/#{date_key}/#{key}")

      expect(xml_value.text).to eq expected_value
    end
  end

  let(:entries_root) { "#{xml_root}/gltransactionentries/glentry" }

  it 'contains expected glentry attributes' do
    GLTRANSACTION_ATTRIBUTES[:gltransactionentries]
      .each_with_index do |entry_attrs, index|
      [
        :trtype,
        :amount,
        :glaccountno,
        :memo,
        :locationid,
        :customerid
      ].each do |key|
        xml_value = function_xml.xpath("#{entries_root}[#{index + 1}]/#{key}")

        expect(xml_value.text).to eq entry_attrs[key]
      end
    end
  end

  it 'contains expected glentry datecreated attribute' do
    GLTRANSACTION_ATTRIBUTES[:gltransactionentries]
      .each_with_index do |entry_attrs, index|
      entry_attrs[:datecreated].each do |key, expected_value|
        datecreated_root = "#{entries_root}[#{index + 1}]/datecreated"
        xml_value = function_xml.xpath("#{datecreated_root}/#{key}")

        expect(xml_value.text).to eq expected_value
      end
    end
  end
end
