module IntacctRuby
  # the gateway by which IntacctRuby::Request instances are sent off to Intacct
  class Api
    def initialize(http_gateway = nil)
      @http_gateway = http_gateway
    end

    def send(request_object, post_request = nil)
      post_request ||= Net::HTTP::Post.new(uri.request_uri)

      post_request['Content-Type'] = 'x-intacct-xml-request'
      post_request.body = request_object.to_xml

      https_request(post_request, uri)
    end

    private

    URI_STRING = 'https://api.intacct.com/ia/xml/xmlgw.phtml'.freeze

    def uri
      @uri ||= URI.parse URI_STRING
    end

    def https_request(request, uri)
      @http_gateway ||= Net::HTTP.new uri.host, uri.port
      @http_gateway.use_ssl = true
      @http_gateway.request request
    end
  end
end
