require 'intacct_ruby/functions/project_base_function'

module IntacctRuby
  module Functions
    # creates a project instance in Intacct
    class UpdateProject < ProjectBaseFunction
      def initialize(attrs = {})
        super("update_project_#{attrs[:projectid]} (#{timestamp})", attrs)
      end

      def to_xml
        super do |xml|
          xml.update_project key: @attrs[:projectid] do
            xml << project_params
          end
        end
      end
    end
  end
end
