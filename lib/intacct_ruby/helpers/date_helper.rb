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

    # Note: @attrs[:startdate] MUST be defined in the invoking context for this
    # bad boy to work
    def start_date_params
      date_params :startdate, @attrs[:startdate]
    end
  end
end
