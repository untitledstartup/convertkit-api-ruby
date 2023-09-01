module ConvertKit
  module Resources
    class TagResponse
      attr_accessor :id, :name, :account_id, :state, :created_at, :updated_at, :deleted_at

      def initialize(response)
        @id = response['id']
        @name = response['name']
        @account_id = response['account_id']
        @state = response['state']
        @created_at = ConvertKit::Utils.to_datetime(response['created_at'])
        @updated_at = ConvertKit::Utils.to_datetime(response['updated_at'])
        @deleted_at = ConvertKit::Utils.to_datetime(response['deleted_at'])
      end
    end
  end
end
