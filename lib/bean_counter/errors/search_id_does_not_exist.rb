module BeanCounter

  module Errors

    class SearchIdDoesNotExist < BeanCountingError

      def initialize(search_name)
        super("No search exists with the name: #{search_name}")
      end

    end

  end

end
