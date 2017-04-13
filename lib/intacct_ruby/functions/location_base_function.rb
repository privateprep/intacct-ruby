require 'intacct_ruby/functions/base_function'
require 'intacct_ruby/helpers/date_helper'

module IntacctRuby
  module Functions
    # base for all location-related functions, to cut down on duplicate code
    class LocationBaseFunction < BaseFunction
      include IntacctRuby::DateHelper

      private

      def location_params
        xml = Builder::XmlMarkup.new

        xml.name     @attrs[:name]
        xml.parentid @attrs[:parentid]

        xml << start_date_params

        xml.target!
      end
    end
  end
end
