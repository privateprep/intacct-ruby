require 'nokogiri'

require 'intacct_ruby/functions/update_customer'

describe IntacctRuby::Functions::UpdateCustomer do
  include IntacctRuby::Functions

  let(:output) do
    generate_function_xml(
      IntacctRuby::Functions::UpdateCustomer,
      customer_attributes
    )
  end

  describe :to_xml do
    let(:attrs) do
      {
        first_name: 'Han',
        last_name: 'Solo',
        type: 'Person',
        customerid: '1',
        email1: 'han@solo.com',
        status: 'active'
      }
    end

    it 'should have a controlid that describes the action' do
      parameter = output.xpath('/function')
                        .first
                        .attributes['controlid']

      expect(parameter.value).to include "update_customer_#{attrs[:customerid]}"
    end

    it 'should contain the ID of the client-to-update' do
      parameter = output.xpath('/function/update_customer')
                        .first
                        .attributes['customerid']

      expect(parameter.value).to eq attrs[:customerid]
    end
  end
end
