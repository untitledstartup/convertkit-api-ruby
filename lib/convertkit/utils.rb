module ConvertKit
  class Utils
    class << self
      def to_datetime(value)
        return nil if !value.is_a?(String) || value.strip.empty?

        DateTime.parse(value)
      end
    end
  end
end
