module ConvertKit
  class Utils
    class << self
      def to_datetime(value)
        return nil if !value.is_a?(String) || value.strip.empty?

        DateTime.iso8601(value)
      end
    end
  end
end
