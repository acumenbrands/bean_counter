module BeanCounter

  class Bean

    attr_reader :target, :cached_data, :identifiers

    def initialize(target)
      @target = target
    end

    def count!
      if find_in_cache
        update_from_cache
        remove_from_cache
      end
    end

    private

    def find_in_cache
      @cached_data ||= identifiers.detect do |identifier|
        BeanCounter::Cache.get(identifier)
      end
    end

    def remove_from_cache
      identifiers.each do |identifier|
        BeanCounter::Cache.delete(identifier)
      end
    end

    def identifiers
      @identifiers ||= identifier_names.map do |name|
        target.send(name)
      end
    end

  end

end
