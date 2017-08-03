require 'spec_helper'
require 'intacct_ruby/api'

describe IntacctRuby::Api do
  describe :send_request do
    it 'sends a request via HTTPS' do
      request_xml = '<xml>some xml</xml>'

      request = mock('Request')
      request.expects(:to_xml).returns request_xml

      post_request_spy = mock('Net::HTTP::Post')
      post_request_spy.expects(:body=).with request_xml
      post_request_spy.expects(:[]=).with 'Content-Type',
                                          'x-intacct-xml-request'

      http_gateway_spy = mock('Net::HTTP')
      http_gateway_spy.expects(:use_ssl=).with true
      http_gateway_spy.expects(:request).with post_request_spy

      Api.new(http_gateway_spy).send_request(request, post_request_spy)
    end
  end
end
