require 'intacct_ruby/legacy_function'

module IntacctRuby
  class LegacyRequest < Request

    # Orders the legacy endpoint params so the API does not complain
    # Each endpoint will need to be defined in the constants file before
    # this logic will enforce the parameter order.
    #
    # Concept:
    #   Ruby has a Hash#deep_merge method that will merge two hashes.
    #   This is useful for our usage here since Ruby keeps the order of
    #   the first hash intact. So defining the properly ordered hash and
    #   merging the passed params into it will transfer values from the
    #   unordered params to the ordered hash and will return the ordered
    #   hash with the valid params values.
    #
    # Example:
    #   ordered = legacy_request.order_params(:record_cctransaction, params)
    #
    def order_params(method, params)
      return params unless Constants::LEGACY.keys.include? method
      order_nested(Constants::LEGACY[method].deep_merge(params), [method])
    end

    private #===================================================================

    def method_missing(method_name, *arguments, &block)
      super unless LegacyFunction::ALLOWED_TYPES.include? method_name.to_s
      @functions << LegacyFunction.new(method_name, arguments.shift, *arguments)
    end

    # Handles order enforcement of nested arrays since deep_merge does not.
    # If the params hash does not contain any nested arrays, this method
    # will return the passed params unmodified.
    #
    # Note:
    #   This method is recursive so handles all nested arrays at all levels.
    #
    # Concept:
    #   Iterate over each key/value pair in the passed hash and check for an
    #   array value. If found, iterate array and recurse for each item in array.
    #   If the value is an array but a matching LEGACY entry does not exist in
    #   the ordered definition, the nested order enforcement will not be perfomed.
    #
    def order_nested(params, path = [])
      params.each do |key, value|
        next unless value.is_a? Array
        next unless Constants::LEGACY.dig(*path.push(key.to_sym))&.first

        value.map! do |nested|
          order_nested(nested, path)
          Constants::LEGACY.dig(*path).first.deep_merge nested
        end
      end

      params
    end
  end
end
