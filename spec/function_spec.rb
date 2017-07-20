require 'spec_helper'
require 'mocha/api'
require 'nokogiri'

require 'intacct_ruby/function'
require 'intacct_ruby/exceptions/unknown_function_type'

include IntacctRuby

def to_xml_key(symbol)
  symbol.to_s.upcase
end

describe Function do
  describe :initialize do
    context 'given a valid function type' do
      it 'creates a function without error' do
        type = Function::ALLOWED_TYPES.first

        expect { Function.new(type, :objecttype, some: 'argument') }
          .not_to raise_error
      end
    end

    context 'given an invalid function type' do
      it 'raises an error' do
        expect { Function.new(:badtype, :objecttype, some: 'argument') }
          .to raise_error Exceptions::UnknownFunctionType
      end
    end
  end

  describe :to_xml do
    let(:function_type) { :create }
    let(:object_type)   { :objecttype }
    let(:arguments) do
      {
        some:           'argument',
        another:        'string',
        nested:         { nested_key: 'nested value' },
        another_nested: { another_key: 'another value' }
      }
    end

    let(:function)      { Function.new(function_type, object_type, arguments) }
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

    context 'given non-nested arguments' do
      it 'has function arguments as key/value pairs' do
        arguments.reject { |_, value| value.is_a? Hash }
                 .each do |key, expected_value|
          xml_object_key = to_xml_key object_type
          xml_argument_key = to_xml_key key

          xml_argument_value = xml.xpath(
            "//#{xml_object_key}/#{xml_argument_key}"
          )

          expect(xml_argument_value.first.children.to_s)
            .to eq expected_value
        end
      end
    end

    context 'given nested arguments' do
      it 'converts those arguments to nested XML' do
        puts xml.to_s
        arguments.select { |_, value| value.is_a? Hash }
                 .each do |key, nested_value|
          xml_object_key = to_xml_key object_type
          xml_outer_key = to_xml_key key

          nested_value.each do |inner_key, inner_value|
            xml_inner_key = to_xml_key inner_key
            xml_inner_value = xml.xpath(
              "//#{xml_object_key}/#{xml_outer_key}/#{xml_inner_key}"
            )

            expect(xml_inner_value.first.children.to_s)
              .to eq inner_value
          end
        end
      end
    end
  end
end
