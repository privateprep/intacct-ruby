require 'intacct_ruby/functions/base_function'

module IntacctRuby
  module Functions
    # function that all item functions are built off of, to decreate dupe code
    class ItemBaseFunction < BaseFunction
      ALL_PARAMS = [
        :name,
        :itemtype,
        :extended_description,
        :productlineid,
        :standard_cost,
        :glgroup,
        :uomgrp
      ].freeze

      def item_params
        xml = Builder::XmlMarkup.new

        ALL_PARAMS.each do |param_name|
          param_value = @attrs[param_name]
          xml.tag!(param_name) { xml << param_value } if param_value
        end

        xml.target!
      end
    end
  end
end
