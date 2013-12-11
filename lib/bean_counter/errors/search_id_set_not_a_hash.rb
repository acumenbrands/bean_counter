module  BeanCounter

  module Errors

    class SearchIdSetNotAHash < BeanCountingError

      def initialize
        super("Could not reference a key in the set of search ids, is it not a Hash?")
      end

    end

  end

end
