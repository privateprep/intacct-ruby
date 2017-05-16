require 'intacct_ruby/functions/base_function'
require 'intacct_ruby/helpers/date_helper'

module IntacctRuby
  module Functions
    # creates gltransaction instance in Intacct
    class GLTransactionBaseFunction < BaseFunction
      include DateHelper

      private

      def gltransaction_header_params(attributes)
        xml = Builder::XmlMarkup.new

        xml << extract_from_attrs(attributes, :journalid)
        xml << date_params(:datecreated, attributes[:datecreated])
        xml << extract_from_attrs(attributes, :description)

        xml.target!
      end

      def gltransactionentry_params(transaction_entries)
        xml = Builder::XmlMarkup.new

        transaction_entries.each do |entry_attrs|
          xml << glentry_params(entry_attrs)
        end

        xml.target!
      end

      def glentry_params(attrs)
        xml = Builder::XmlMarkup.new

        xml.glentry do
          xml << extract_from_attrs(attrs, :trtype, :amount, :glaccountno)
          xml << date_params(:datecreated, attrs[:datecreated])
          xml << extract_from_attrs(
            attrs,
            :memo,
            :locationid,
            :customerid,
            :employeeid,
            :projectid,
            :itemid
          )
        end

        xml.target!
      end

      def extract_from_attrs(attributes_hash, *keys)
        xml = Builder::XmlMarkup.new

        keys.each do |key|
          value = attributes_hash[key]
          xml.tag!(key) { xml << value.to_s } if value
        end

        xml.target!
      end
    end
  end
end
