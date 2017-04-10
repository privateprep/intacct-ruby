require 'nokogiri'

require 'intacct_ruby/functions/update_customer'

describe IntacctRuby::Functions::UpdateCustomer do
  include IntacctRuby::Functions

  describe :to_xml do
    let(:attrs) do
      {
        first_name: 'Han',
        last_name: 'Solo',
        type: 'Person',
        id: '1',
        email1: 'han@solo.com',
        status: 'active'
      }
    end

    let(:output) do
      request = IntacctRuby::Functions::UpdateCustomer.new(attrs)
      Nokogiri::XML(request.to_xml)
    end

    it 'should have a controlid that describes the action' do
      parameter = output.xpath('/function')
                        .first
                        .attributes['controlid']

      expect(parameter.value).to include('update_customer')
    end

    it 'should contain the ID of the client-to-update' do
      parameter = output.xpath('/function/update_customer')
                        .first
                        .attributes['customerid']

      expect(parameter.value).to eq attrs[:id]
    end
  end
end
