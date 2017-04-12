def function_base_path(function_name)
  "/function/#{function_name}"
end

def generate_function_xml(function_class, attributes)
  Nokogiri::XML function_class.new(attributes).to_xml
end
