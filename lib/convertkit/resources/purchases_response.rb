module ConvertKit
  module Resources
    class PurchasesResponse
      attr_accessor :purchases, :total_purchases, :page, :total_pages

      def initialize(response)
        @total_purchases = response['total_purchases']
        @page = response['page']
        @total_pages = response['total_pages']
        @purchases = response['purchases'].map do |subscriber|
          ConvertKit::Resources::PurchaseResponse.new(subscriber)
        end
      end
    end
  end
end
