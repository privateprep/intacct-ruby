# frozen_string_literal: true

require 'intacct_ruby'
require 'builder'
require 'mocha/api'
require 'response_factory'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
  config.disable_monkey_patching!
end
