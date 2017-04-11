require 'nokogiri'

def project_attributes(overrides = {})
  {
    projectid: '1',
    name: 'Some test project',
    projectcategory: 'Some category',
    customerid: '2',
    customfields: {
      custom_field_1: 'Custom Field 1 Value',
      custom_field_2: 'Custom Field 2 Value'
    }
  }.merge(overrides)
end

def generate_function_xml(function_class, attributes)
  Nokogiri::XML function_class.new(attributes).to_xml
end

# function_name refers to the name that identifies the function to intacct,
# usually a snake-case variant of the class name.
shared_examples 'a project function' do |function_name, attributes|
  let(:base_path) { "/function/#{function_name}" }

  let(:xml_output) { generate_function_xml(described_class, attributes) }

  it 'contains expected standard params' do
    [:projectid, :name, :projectcategory, :customerid].each do |param_key|
      param = xml_output.xpath("#{base_path}/#{param_key}")
      expected = attributes[param_key]

      expect(param.text)
        .to eq(expected),
            "Value mismatch on #{param_key}. Expected " \
            "\"#{attributes[param_key]}\", got \"#{param.text}\""
    end
  end

  let(:custom_fields_path) { "#{base_path}/customfields/customfield" }

  it 'contains expected customfield params' do
    xml_output.xpath(custom_fields_path).each do |field|
      field_key = field.xpath('customfieldname').text
      field_value = field.xpath('customfieldvalue').text

      expected_value = attributes[:customfields][field_key.to_sym]

      expect(field_value)
        .to eq(expected_value),
            "Value mismatch on #{field_key}. Expected " \
            "\"#{expected_value}\", got \"#{field_value}\""
    end
  end
end
