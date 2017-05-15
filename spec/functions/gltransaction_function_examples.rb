require 'nokogiri'

def transaction_entry_params
  (1..3).to_a.each_with_object([]) do |i, repo|
    repo << {
      trtype:      "glentry#{i} trtype",
      amount:      "glentry#{i} amount",
      glaccountno: "glentry#{i} glaccountno",
      datecreated: {
        year:  "glentry#{i} year",
        month: "glentry#{i} month",
        day:   "glentry#{i} day"
      },
      memo:       "glentry#{i} memo",
      locationid: "glentry#{i} locationid",
      customerid: "glentry#{i} customerid",
      employeeid: "glentry#{i} employeeid"
    }
  end
end

def generate_transaction_attributes(transaction_type)
  {
    journalid: 'some journalid',
    datecreated: {
      year:  'top-level year',
      month: 'top-level month',
      day:   'top-level day'
    },
    description: "some description for #{transaction_type}transactions"
  }.merge(
    "#{transaction_type}transactionentries".to_sym => transaction_entry_params
  )
end

shared_examples 'a gltransaction function' do |fn_name, type, attrs, fn_xml|
  # "type" describes transaction type: either :gl or :statgl
  # "attrs" are the attributes used to generate the function XML

  let(:xml_root) do
    fn_xml.xpath("function/#{fn_name}")
  end

  it 'contains expected top-level fields' do
    [:journalid, :description].each do |key|
      xml_value = xml_root.xpath(key.to_s)

      expect(xml_value.text).to eq attrs[key]
    end
  end

  it 'contains expected top-level datecreated attribute' do
    date_key = :datecreated

    attrs[date_key].each do |key, expected_value|
      xml_value = xml_root.xpath("#{date_key}/#{key}")

      expect(xml_value.text).to eq expected_value
    end
  end

  let(:entries_root_name) { "#{type}transactionentries"}
  let(:entries_root) { xml_root.xpath(entries_root_name) }

  it 'contains expected glentry attributes' do
    attrs[entries_root_name.to_sym]
      .each_with_index do |entry_attrs, index|
      [
        :trtype,
        :amount,
        :glaccountno,
        :memo,
        :locationid,
        :customerid,
        :employeeid
      ].each do |key|
        xml_value = entries_root.xpath("glentry[#{index + 1}]/#{key}")

        expect(xml_value.text).to eq entry_attrs[key]
      end
    end
  end

  it 'contains expected glentry datecreated attribute' do
    attrs[entries_root_name.to_sym]
      .each_with_index do |entry_attrs, index|
      datecreated_root = entries_root.xpath(
        "glentry[#{index + 1}]/datecreated"
      )

      entry_attrs[:datecreated].each do |key, expected_value|
        xml_value = datecreated_root.xpath(key.to_s)

        expect(xml_value.text).to eq expected_value
      end
    end
  end
end
