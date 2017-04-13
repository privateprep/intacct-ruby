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

# function_name refers to the name that identifies the function to intacct,
# usually a snake-case variant of the class name.
shared_examples 'a project function' do |function_xml|
  let(:base_path) { function_base_path(function_name) }

  let(:function_name) { function_name_from(function_xml) }

  it 'contains expected standard params' do
    [:projectid, :name, :projectcategory, :customerid].each do |param_key|
      param = function_xml.xpath("#{base_path}/#{param_key}")
      expected = project_attributes[param_key]

      expect(param.text)
        .to eq(expected),
            "Value mismatch on #{param_key}. Expected " \
            "\"#{project_attributes[param_key]}\", got \"#{param.text}\""
    end
  end

  let(:custom_fields_path) { "#{base_path}/customfields/customfield" }

  it 'contains expected customfield params' do
    function_xml.xpath(custom_fields_path).each do |field|
      field_key = field.xpath('customfieldname').text
      field_value = field.xpath('customfieldvalue').text

      expected_value = project_attributes[:customfields][field_key.to_sym]

      expect(field_value)
        .to eq(expected_value),
            "Value mismatch on #{field_key}. Expected " \
            "\"#{expected_value}\", got \"#{field_value}\""
    end
  end
end
