module IntacctRuby
  class LegacyFunction < Function

    def to_xml
      xml = Builder::XmlMarkup.new

      xml.function controlid: controlid do
        xml.tag! @object_type do
          xml << parameter_xml(@parameters)
        end
      end

      xml.target!
    end
  end
end
