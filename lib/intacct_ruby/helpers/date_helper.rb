require 'builder'

module IntacctRuby
# methods to help generate date XML for calls
  module DateHelper
    def date_params(block_name, attrs = {})
      xml = Builder::XmlMarkup.new

      xml.tag!(block_name) do
        xml.year  attrs[:year]
        xml.month attrs[:month]
        xml.day   attrs[:day]
      end
    end
  end
end
