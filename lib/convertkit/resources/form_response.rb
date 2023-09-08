module ConvertKit
  module Resources
    class FormResponse
      attr_reader :id, :uid, :name, :type, :embed_js, :embed_url, :archived, :created_at

      def initialize(response)
        @id = response['id']
        @uid = response['uid']
        @name = response['name']
        @type = response['type']
        @embed_js = response['embed_js']
        @embed_url = response['embed_url']
        @archived = response['archived']
        @created_at = ConvertKit::Utils.to_datetime(response['created_at'])
      end
    end
  end
end
