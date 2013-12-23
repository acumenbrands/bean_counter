module BeanCounter

  module Cache

    extend self

    def record_search_results(items_to_cache)
      items_to_cache.each { |item| write_to_cache(item) }
    end

    def write_to_cache(item)
      namespace.set(item[:columns][:displayname], quantity_json(item))
      namespace.set(item[:columns][:upccode],     quantity_json(item))
    end

    def quantity_json(item)
      {
        vendor:    item[:columns][Config.netsuite_vendor_quantity_field],
        warehouse: item[:columns][Config.netsuite_warehouse_quantity_field]
      }.to_json
    end

    def get(identifier)
      namespace.get(identifier)
    end

    def delete(identifier)
      namespace.del(identifier)
    end

    private

    def namespace
      @namespace ||= Redis::Namespace.new(Config.cache_namespace)
    end

  end

end