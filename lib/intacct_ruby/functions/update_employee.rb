require 'intacct_ruby/functions/employee_base_function'

module IntacctRuby
  module Functions
    # function used to update employee instances
    class UpdateEmployee < EmployeeBaseFunction
      def initialize(attrs = {})
        super("update_employee_#{attrs[:employeeid]} (#{timestamp})", attrs)
      end

      def to_xml
        super do |xml|
          xml.update_employee employeeid: @attrs[:employeeid] do
            xml << employee_params
          end
        end
      end
    end
  end
end
