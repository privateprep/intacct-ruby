require 'intacct_ruby/functions/base_function'

module IntacctRuby
  module Functions
    # contains shared code for creating and updating projects
    class ProjectBaseFunction < BaseFunction
      def initialize(controlid, attrs = {})
        @attrs = attrs

        super(controlid)
      end

      private

      def project_params
        xml = Builder::XmlMarkup.new

        [:projectid, :name, :projectcategory, :customerid].each do |key|
          xml.tag!(key.to_s) { xml << @attrs[key].to_s }
        end

        xml << custom_field_params(@attrs[:customfields])

        xml.target!
      end
    end
  end
end
