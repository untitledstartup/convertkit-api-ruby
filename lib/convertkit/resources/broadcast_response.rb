module ConvertKit
  module Resources
    class BroadcastResponse
      attr_accessor :id,
                    :subject,
                    :description,
                    :content,
                    :public,
                    :email,
                    :email_layout_template,
                    :thumbnail_url,
                    :thumbnail_alt,
                    :created_at,
                    :published_at,
                    :send_at

      def initialize(response)
        @id = response['id']
        @subject = response['subject']
        @description = response['description']
        @content = response['content']
        @public = response['public']
        @email = response['email_address']
        @email_layout_template = response['email_layout_template']
        @thumbnail_url = response['thumbnail_url']
        @thumbnail_alt = response['thumbnail_alt']
        @created_at = ConvertKit::Utils.to_datetime(response['created_at'])
        @published_at = ConvertKit::Utils.to_datetime(response['published_at'])
        @send_at = ConvertKit::Utils.to_datetime(response['send_at'])
      end
    end
  end
end
