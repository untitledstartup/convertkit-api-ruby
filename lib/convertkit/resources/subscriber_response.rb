module ConvertKit
  module Resources
    class SubscriberResponse
      attr_accessor :id, :first_name, :email, :state, :fields, :created_at

      def initialize(response)
        @id = response['id']
        @first_name = response['first_name']
        @email = response['email_address']
        @state = response['state']
        @fields = response['fields']
        @created_at = ConvertKit::Utils.to_datetime(response['created_at'])
      end
    end

    class TaggedSubscriberResponse
      attr_accessor :id, :first_name, :email, :created_at, :tagged_at

      def initialize(response)
        @id = response['id']
        @first_name = response['first_name']
        @email = response['email_address']
        @created_at = ConvertKit::Utils.to_datetime(response['created_at'])
        @tagged_at = ConvertKit::Utils.to_datetime(response['tagged_at'])
      end
    end
  end
end
