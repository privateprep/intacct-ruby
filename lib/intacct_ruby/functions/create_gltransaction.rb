require 'intacct_ruby/functions/base_function'
require 'intacct_ruby/helpers/date_helper'

module IntacctRuby
  module Functions
    # creates gltransaction instance in Intacct
    class CreateGLTransaction < BaseFunction
      include DateHelper

      def initialize(attrs = {})
        super "create_gltransaction (#{attrs[:description]} #{timestamp})",
              attrs
      end

      def to_xml
        super do |xml|
          xml.create_gltransaction do
            xml << extract_from_attrs(@attrs, :journalid)
            xml << date_params(:datecreated, @attrs[:datecreated])
            xml << extract_from_attrs(@attrs, :description)

            xml.gltransactionentries do
              xml << gltransactionentry_params(@attrs[:gltransactionentries])
            end
          end
        end
      end

      private

      def gltransactionentry_params(transaction_entries)
        xml = Builder::XmlMarkup.new

        transaction_entries.each do |entry_attrs|
          xml << gl_entry_params(entry_attrs)
        end

        xml.target!
      end

      def gl_entry_params(attrs)
        xml = Builder::XmlMarkup.new

        xml.glentry do
          xml << extract_from_attrs(attrs, :trtype, :amount, :glaccountno)
          xml << date_params(:datecreated, attrs[:datecreated])
          xml << extract_from_attrs(attrs, :memo, :locationid, :customerid, :employeeid)
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
