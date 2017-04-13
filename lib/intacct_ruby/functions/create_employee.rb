require 'intacct_ruby/functions/employee_base_function'

module IntacctRuby
  module Functions
    # Function that creates an employee instance in Intacct
    class CreateEmployee < EmployeeBaseFunction
      def initialize(attrs = {})
        super("create_employee_#{attrs[:employeeid]}", attrs)
      end

      def to_xml
        super do |xml|
          xml.create_employee do
            xml.employeeid @attrs[:employeeid]
            xml << employee_params
          end
        end
      end
    end
  end
end
