module BeanCounter

  module Errors

    class BeanCountingError < StandardError

      def initialize(message)
        super(message)
      end

    end

  end

end
