# frozen_string_literal: true

# for generating responses to be used in testing
class ResponseFactory
  def self.generate_response
    xml = Builder::XmlMarkup.new

    xml.instruct!
    xml.response do
      xml << control_block
      xml.operation do
        xml << authentication_block
        yield(xml)
      end
    end
  end

  def self.generate_success
    generate_response do |xml|
      xml << success_result_block
    end
  end

  def self.generate_with_errors(errors)
    generate_response do |xml|
      xml << error_result_block(errors)
    end
  end

  CONTROL_BLOCK_DEFAULTS = {
    status: 'success',
    senderid: 'some_sender_id',
    controlid: 'some_timestamp',
    uniqueid: 'false',
    dtdversion: '3.0'
  }.freeze

  def self.build_xml_from_attributes(attributes)
    xml = Builder::XmlMarkup.new

    attributes.each do |key, value|
      xml.tag!(key) { xml << value }
    end

    xml.target!
  end

  def self.control_block(**overrides)
    attributes = CONTROL_BLOCK_DEFAULTS.dup.merge(overrides)
    xml = Builder::XmlMarkup.new

    xml.control do
      xml << build_xml_from_attributes(attributes)
    end

    xml.target!
  end

  AUTHENTICATION_BLOCK_DEFAULTS = {
    status: 'success',
    userid: 'some_user_id',
    companyid: 'some_company_id',
    sessiontimestamp: '2017-01-27T09:09:31-08:00'
  }.freeze

  def self.authentication_block(**overrides)
    attributes = AUTHENTICATION_BLOCK_DEFAULTS.dup.merge(overrides)
    xml = Builder::XmlMarkup.new

    xml.authentication do
      xml << build_xml_from_attributes(attributes)
    end

    xml.target!
  end

  RESULT_BLOCK_DEFAULTS = {
    status: 'success',
    function: 'some_function',
    controlid: 'some_control_id'
  }.freeze

  def self.success_result_block(**overrides)
    attributes = RESULT_BLOCK_DEFAULTS.dup.merge(overrides)
    attributes[:key] ||= 'some_key'

    xml = Builder::XmlMarkup.new

    xml.result do
      xml << build_xml_from_attributes(attributes)
    end

    xml.target!
  end

  def self.error_result_block(errors, **overrides)
    attributes = RESULT_BLOCK_DEFAULTS.dup.merge(overrides)
    attributes[:errormessage] = errormessage_block(errors)
  end

  def self.errormessage_block(errors)
    xml = Builder::XmlMarkup.new

    errors.each do |error|
      xml.error do
        xml.description2 error
      end
    end

    xml.target!
  end
end
