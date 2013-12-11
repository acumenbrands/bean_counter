module BeanCounter

  module Cache

    class Item

      attr_accessor :identifier, :value

      def initialize(identifier=nil, value=nil)
        @identifier = identifier
        @value      = value
      end

    end

  end

end
