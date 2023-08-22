module ConvertKit
  # The client is responsible for making requests to the ConvertKit API. It requires that an auth token is provided.
  # Without a valid token, the client will not be able to retrieve data from the API.
  # The ConvertKit OAuth class can be used to obtain this token.
  class Client
    API_URL = 'https://api.convertkit.com/alpha'.freeze # Using Alpha API as this is currently in active development
    def initialize(auth_token)
      @conn = ConvertKit::ConnectionHelper.get_connection(API_URL, auth_token: auth_token)
    end

    def account
      @account ||= ConvertKit::Resources::Account.new(self)
    end

    def get(path, params = {})
      response = @conn.get(path, params)
      handle_response(response)
    end

    def post(path, params = {})
      response = @conn.post(path, params)
      handle_response(response)
    end

    private

    def handle_response(response)
      if response.success?
        response.body
      else
        raise ConvertKit::APIError, response.body
      end
    end
  end
end
