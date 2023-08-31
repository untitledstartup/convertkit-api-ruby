module ConvertKit
  module Resources
    class TagResponse
      attr_accessor :id, :name, :account_id, :state, :created_at, :updated_at, :deleted_at

      def initialize(response)
        @id = response['id']
        @name = response['name']
        @account_id = response['account_id']
        @state = response['state']
        @created_at = DateTime.parse(response['created_at']) unless response.fetch('created_at', '').strip.empty?
        @updated_at = DateTime.parse(response['updated_at']) unless response.fetch('updated_at', '').strip.empty?
        @deleted_at = DateTime.parse(response['deleted_at']) unless response.fetch('deleted_at', '').strip.empty?
      end
    end
  end
end
