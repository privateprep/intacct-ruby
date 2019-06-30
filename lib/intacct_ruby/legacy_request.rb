require 'intacct_ruby/legacy_function'

module IntacctRuby
  class LegacyRequest < Request

    private

    def method_missing(method_name, *arguments, &block)
      super unless LegacyFunction::ALLOWED_TYPES.include? method_name.to_s
      @functions << LegacyFunction.new(method_name, arguments.shift, *arguments)
    end
  end
end
