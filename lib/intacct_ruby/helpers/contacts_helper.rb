module IntacctRuby
  # methods to avoid duplication when creating and updating contact records
  module ContactsHelper
    def contact_params(attributes, id, person_type)
      xml = Builder::XmlMarkup.new

      name = full_name(attributes)

      xml.contact do
        xml.contactname contactname(name, id, person_type)
        xml.printas     full_name(attributes)
        xml.firstname   attributes[:first_name]
        xml.lastname    attributes[:last_name]
        xml.email1      attributes[:email1]
      end

      xml.target!
    end

    def contactname(name, id, person_type)
      # a unique identifier for a contact, to be used for Intacct's
      # contactname field. Person Type required to ensure that there aren't
      # duplicates (e.g. a customer and employee w/ ID 1 both named
      # 'John Smith')
      "#{name} (#{person_type} \##{id})"
    end

    def full_name(attrs = {})
      "#{attrs[:first_name]} #{attrs[:last_name]}"
    end
  end
end
