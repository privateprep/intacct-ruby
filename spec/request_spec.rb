require 'spec_helper'
require 'mocha/api'
require 'intacct_ruby/request'
require 'nokogiri'
require 'figaro'

include IntacctRuby

# For all ENVs in this format:
# xml_key represents the key associated with each ENV in the request produced
CONTROL_BLOCK_ENVS = {
  INTACCT_SENDER_ID: {
    xml_key: 'senderid',
    value: 'senderid_value'
  },
  INTACCT_SENDER_PW: {
    xml_key: 'password',
    value: 'sender_password'
  }
}.freeze

AUTHENTICATION_BLOCK_ENVS = {
  INTACCT_USER_ID: {
    xml_key: 'userid',
    value: 'userid_value'
  },
  INTACCT_COMPANY_ID: {
    xml_key: 'companyid',
    value: 'companyid_value'
  },
  INTACCT_USER_PW: {
    xml_key: 'password',
    value: 'user_password'
  }
}.freeze

def stub_envs
  CONTROL_BLOCK_ENVS.merge(AUTHENTICATION_BLOCK_ENVS).each do |name, attrs|
    Figaro.env.stubs(name).returns attrs[:value]
  end
end

def generate_request_xml(*args)
  @request_xml ||= begin
    args = function_stubs if args.empty?
    Nokogiri::XML Request.new(*args).to_xml
  end
end

def control_block_xml
  @control_block_xml ||= @request_xml.xpath('/request/control')
end

def operation_block_xml
  @operation_block_xml ||= @request_xml.xpath('/request/operation')
end

def get_value_from(xml, node_name)
  xml.xpath(node_name).text
end

def function_stubs
  @function_stubs ||= %i(function_a function_b).map do |function|
    mock do
      stubs(:to_xml).returns("[#{function}]")
    end
  end
end

describe Request do
  before(:all) { stub_envs }

  context 'with no overrides' do
    before(:all) { generate_request_xml }

    describe 'control block' do
      it 'contains values from environmental variables' do
        CONTROL_BLOCK_ENVS.each do |_, attrs|
          expected = attrs[:value]
          actual = get_value_from control_block_xml, attrs[:xml_key]

          expect(actual).to eq expected
        end
      end

      it 'contains valid controlid' do
        controlid = get_value_from control_block_xml, 'controlid'

        # if controlid is not a valid datetime string, this will blow up
        expect { DateTime.parse(controlid) }.not_to raise_error
      end

      it 'contains a control block with default values' do
        %i(uniqueid dtdversion includewhitespace).each do |field_name|
          expected_value = Request::DEFAULTS[field_name].to_s
          actual_value = get_value_from control_block_xml, field_name.to_s

          expect(expected_value).to eq actual_value
        end
      end
    end

    describe 'authentication block' do
      it 'contains values from environmental variables' do
        authentication_block_xml = @request_xml.xpath(
          '/request/operation/authentication/login'
        )

        AUTHENTICATION_BLOCK_ENVS.each do |_, attrs|
          actual = get_value_from authentication_block_xml, attrs[:xml_key]

          expect(actual).to eq attrs[:value]
        end
      end
    end

    describe 'operation block' do
      it 'shows transaction default' do
        expect(operation_block_xml.first.attributes['transaction'].value)
          .to eq Request::DEFAULTS[:transaction].to_s
      end
    end

    describe 'content block' do
      it 'contains function payloads' do
        content_block = operation_block_xml.xpath('content').text
        function_stubs.each do |function|
          expect(content_block).to include function.to_xml
        end
      end
    end
  end

  context 'with overrides' do
    describe 'control block' do
      it 'shows overrides instead of defaults' do
        overrides = {
          uniqueid: 'uniqueid override',
          dtdversion: 'dtdversion override',
          includewhitespace: 'includewhitespace override'
        }

        generate_request_xml(*function_stubs, overrides)

        overrides.each do |field_name, field_value|
          request_value = get_value_from control_block_xml, field_name.to_s

          expect(request_value).to eq field_value
        end
      end
    end

    describe 'operations block' do
      it 'shows overrides instead of defaults' do
        transaction_override_value = 'Transaction Override'

        generate_request_xml(
          *function_stubs,
          transaction: transaction_override_value
        )

        request_attribute = operation_block_xml.first.attributes['transaction']

        expect(request_attribute.value).to eq transaction_override_value
      end
    end
  end
end
