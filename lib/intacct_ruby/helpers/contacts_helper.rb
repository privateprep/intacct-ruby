module IntacctRuby
  # methods to avoid duplication when creating and updating contact records
  module ContactsHelper
    def contact_params(attributes = {})
      xml = Builder::XmlMarkup.new

      xml.contact do
        xml.contactname contactname(attributes)
        xml.printas     full_name(attributes)
        xml.firstname   attributes[:first_name]
        xml.lastname    attributes[:last_name]
        xml.email1      attributes[:email1]
      end

      xml.target!
    end

    def contactname(attrs = {})
      # a unique identifier for a contact, to be used for Intacct's
      # contactname field
      "#{full_name(attrs)} (#{attrs[:person_type]} \##{attrs[:id]})"
    end

    def full_name(attrs = {})
      "#{attrs[:first_name]} #{attrs[:last_name]}"
    end
  end
end
