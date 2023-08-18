module CovertKit
  class Connection
    def initialize(url, options = {})
      @url = url

      @conn = Faraday.new(url: @url) do |builder|
        builder.request :json
        builder.response :json

        if options[:auth_token]
          builder.authorization :Bearer, options[:auth_token]
        end
      end
    end
  end
end
