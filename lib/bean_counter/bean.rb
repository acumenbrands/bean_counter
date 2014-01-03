module BeanCounter

  class Bean

    attr_reader :target

    def initialize(target)
      @target = target
    end

    def count!
      if cached_data && update_from_cache
        remove_from_cache
      end
    end

    def identifiers
      identifier_names.map do |name|
        target.send(name)
      end
    end

    protected

    def cached_data
      @cached_data ||= find_in_cache.detect do |cached_data|
        !cached_data.nil?
      end
    end

    def find_in_cache
      identifiers.map do |identifier|
        BeanCounter::Cache.get(identifier)
      end
    end

    def remove_from_cache
      identifiers.each do |identifier|
        BeanCounter::Cache.delete(identifier)
      end
    end

    def update_from_cache
      raise NotImplementedError
    end

  end

end
