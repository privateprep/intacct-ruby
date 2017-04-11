require 'intacct_ruby/functions/project_base_function'

module IntacctRuby
  module Functions
    # creates a project instance in Intacct
    class CreateProject < ProjectBaseFunction
      def initialize(attrs = {})
        super("create_project_#{attrs[:projectid]}", attrs)
      end

      def to_xml
        super do |xml|
          xml.create_project do
            xml << project_params
          end
        end
      end
    end
  end
end
