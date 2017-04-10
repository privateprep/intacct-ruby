require 'intacct_ruby/helpers/contacts_helper'
require 'builder'
require 'nokogiri'

describe IntacctRuby::ContactsHelper do
  include IntacctRuby::ContactsHelper

  describe :full_name do
    it "returns the contact's full name" do
      attrs = { first_name: 'Han', last_name: 'Solo' }

      expect(full_name(attrs))
        .to eq "#{attrs[:first_name]} #{attrs[:last_name]}"
    end
  end

  describe :contactname do
    it 'returns an unique identifier for that contact' do
      attrs = {
        first_name: 'Han',
        last_name: 'Solo',
        person_type: 'Space Outlaw',
        id: '1'
      }

      expect(contactname(attrs))
        .to eq "#{attrs[:first_name]} #{attrs[:last_name]} " \
               "(#{attrs[:person_type]} \##{attrs[:id]})"
    end
  end

  describe :contact_params do
    let(:attrs) do
      {
        first_name: 'Han',
        last_name: 'Solo',
        person_type: 'Space Outlaw',
        id: '1',
        email1: 'han@solo.com'
      }
    end

    let(:output) { Nokogiri::XML contact_params(attrs) }

    it 'contains expected params' do
      {
        contactname: contactname(attrs),
        printas: full_name(attrs),
        firstname: attrs[:first_name],
        lastname: attrs[:last_name],
        email1: attrs[:email1]
      }.each do |parameter_key, expected_value|
        parameter = output.xpath("/contact/#{parameter_key}")
        expect(parameter.text).to eq expected_value
      end
    end
  end
end
