require 'intacct_ruby/functions/gltransaction_base_function'
require 'intacct_ruby/helpers/date_helper'

module IntacctRuby
  module Functions
    # creates gltransaction instance in Intacct
    class CreateStatGLTransaction < GLTransactionBaseFunction
      include DateHelper

      def initialize(attrs = {})
        super "create_statgltransaction (#{attrs[:description]} #{timestamp})",
              attrs
      end

      def to_xml
        super do |xml|
          xml.create_statgltransaction do
            xml << gltransaction_header_params(@attrs)

            xml.statgltransactionentries do
              xml << gltransactionentry_params(@attrs[:statgltransactionentries])
            end
          end
        end
      end
    end
  end
end
