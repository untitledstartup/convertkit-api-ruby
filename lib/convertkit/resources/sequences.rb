module ConvertKit
  module Resources
    class Sequences
      PATH = 'sequences'.freeze

      def initialize(client)
        @client = client
      end

      # Returns a list of sequences for the account.
      # See https://developers.convertkit.com/#list-sequences for details
      def list
        response = @client.get(PATH)

        # TODO: Double check to see if this has now been updated to sequences instead of the old naming convention of courses.
        response['courses'].map do |sequence|
          ConvertKit::Resources::SequenceResponse.new(sequence)
        end
      end
    end
  end
end
