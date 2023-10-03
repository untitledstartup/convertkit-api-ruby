module ConvertKit
  # The client is responsible for making requests to the ConvertKit API. It requires that an auth token is provided.
  # Without a valid token, the client will not be able to retrieve data from the API.
  # The ConvertKit OAuth class can be used to obtain this token.
  class Client
    API_URL = 'https://api.convertkit.com/alpha'.freeze # Using Alpha API as this is currently in active development
    HTTP_METHODS = %i[get post delete put].freeze

    def initialize(auth_token)
      @connection = ConvertKit::Connection.new(API_URL, auth_token: auth_token)
    end

    def account
      @account ||= ConvertKit::Resources::Account.new(self)
    end

    def tags
      @tags ||= ConvertKit::Resources::Tags.new(self)
    end

    def subscribers
      @subscribers ||= ConvertKit::Resources::Subscribers.new(self)
    end

    def sequences
      @sequences ||= ConvertKit::Resources::Sequences.new(self)
    end

    def custom_fields
      @custom_fields ||= ConvertKit::Resources::CustomFields.new(self)
    end

    def webhooks
      @webhooks ||= ConvertKit::Resources::Webhooks.new(self)
    end

    def forms
      @forms ||= ConvertKit::Resources::Forms.new(self)
    end

    def broadcasts
      @broadcasts ||= ConvertKit::Resources::Broadcasts.new(self)
    end

    def purchases
      @purchases ||= ConvertKit::Resources::Purchases.new(self)
    end

    # Defined wrapper methods for ConvertKit Connection methods
    HTTP_METHODS.each do |method|
      define_method(method) do |path, params = {}, raw_response = false|
        response = @connection.public_send(method, path, params)
        handle_response(response, raw_response)
      end
    end

    private

    def handle_response(response, raw_response= false)
      if response.success?
        raw_response ? response: response.body
      else
        # TODO add more specific error handling with different error classes
        raise ConvertKit::APIError, "#{response.status}: #{response.body}"
      end
    end
  end
end
