require 'spec_helper'
require 'mocha/api'
require 'nokogiri'

require 'intacct_ruby/function'
require 'intacct_ruby/exceptions/unknown_function_type'

include IntacctRuby

def to_xml_key(symbol)
  symbol.to_s
end

describe Function do
  describe :initialize do
    context 'given a valid function type' do
      it 'creates a function without error' do
        type = Function::ALLOWED_TYPES.first

        expect { Function.new(type, object_type: :objecttype, parameters: {some: 'parameter'}) }
          .not_to raise_error
      end
    end

    context 'given an invalid function type' do
      it 'raises an error' do
        expect { Function.new(:badtype, object_type: :objecttype, parameters: {some: 'parameter'}) }
          .to raise_error Exceptions::UnknownFunctionType
      end
    end
  end

  describe :to_xml do
    let(:function_type) { :create }
    let(:object_type)   { :OBJECTTYPE }
    let(:parameters) do
      {
        some:           'parameter',
        another:        'string',
        risky:          'risky&><parameter',
        nested_as_hash:         { nested_key: 'nested > value' },
        another_nested_as_hash: { another_key: 'another < value' },
        nested_as_array: [
          { first_key:  'first_value <'  },
          { second_key: 'second_value >' }
        ]
      }
    end

    let(:function)      { Function.new(function_type, object_type: object_type, parameters: parameters) }
    let(:xml)           { Nokogiri::XML function.to_xml }

    it 'has a controlid' do
      xml_controlid = xml.xpath('function').first.attributes['controlid'].value

      expect(xml_controlid)
        .to include function_type.to_s, object_type.to_s
    end

    it 'has a function type' do
      expect(xml.xpath('function').children.first.name)
        .to eq function_type.to_s
    end

    it 'has an object type with proper formatting' do
      expect(xml.xpath("//#{function_type}").children.first.name)
        .to eq object_type.to_s.upcase
    end

    context 'given non-nested parameters' do
      it 'has function parameters as key/value pairs' do
        parameters.select { |_, value| [String, Integer].include?(value.class) }
                 .each do |key, expected_value|
          xml_object_key = to_xml_key object_type
          xml_parameter_key = to_xml_key key

          xml_parameter_value = xml.xpath(
            "//#{xml_object_key}/#{xml_parameter_key}"
          )

          expect(xml_parameter_value.first.children.to_s)
            .to eq expected_value.encode(xml: :text)
        end
      end
    end

    context 'given nested parameters' do
      context 'given that nested parameters are in hash' do
        it 'converts those parameters to nested XML' do
          parameters.select { |_, value| value.is_a? Hash }
                   .each do |key, nested_value|
            xml_object_key = to_xml_key object_type
            xml_outer_key = to_xml_key key

            nested_value.each do |inner_key, inner_value|
              xml_inner_key = to_xml_key inner_key
              xml_inner_value = xml.xpath(
                "//#{xml_object_key}/#{xml_outer_key}/#{xml_inner_key}"
              )

              expect(xml_inner_value.first.children.to_s)
                .to eq inner_value.encode(xml: :text)
            end
          end
        end
      end

      context 'given that those parameters are in an array' do
        it 'converts those parameters to an XML list' do
          parameters.select { |_, value| value.is_a? Array }
                   .each do |outer_key, array_body|
            xml_object_key = to_xml_key object_type
            xml_array_key = to_xml_key outer_key # key of XML Array
            array_body.each do |hash_entry| # because array of hashes
              hash_entry.each do |array_item_key, array_item_value|
                xml_array_item_key = to_xml_key array_item_key
                xml_array_item_value = xml.xpath(
                  "//#{xml_object_key}/#{xml_array_key}/#{xml_array_item_key}"
                )

                expect(xml_array_item_value.first.children.to_s)
                  .to eq array_item_value.encode(xml: :text)
              end
            end
          end
        end
      end
    end
  end
end
