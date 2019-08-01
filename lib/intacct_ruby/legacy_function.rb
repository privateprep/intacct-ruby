module IntacctRuby
  class LegacyFunction < Function

    def to_xml
      xml = Builder::XmlMarkup.new
      
      attributes = @parameters.select { |k,v| /^\*/.match(k) }
      attributes = attributes.inject({}) do |hash, (k, v)|
        hash[k.to_s.gsub(/^\*/, '')] = v
        hash
      end unless attributes.empty?

      xml.function controlid: controlid do
        xml.tag! @object_type, attributes do
          xml << parameter_xml(@parameters.reject { |k,v| /^\*/.match(k) })
        end
      end

      xml.target!
    end
  end
end
