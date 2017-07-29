module Delayed
  module Backend
    class InvalidPayload
      ParseObjectFromYaml = %r{\!ruby/\w+\:([^\s]+)} # rubocop:disable ConstantName

      def initialize(handler, exception)
        @handler, @exception = handler, deserialization_error(exception)
      end

      def display_name
        result = ParseObjectFromYaml.match(@handler)
        result && result[1] || self.class.name
      end

      def perform
        raise @exception
      end

      def deserialization_error(e)
        return e if e.kind_of?(DeserializationError)
        DeserializationError.new "Job failed to load: #{e.message}. Handler: #{@handler.inspect}"
      end
    end
  end
end
