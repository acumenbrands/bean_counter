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
      {}.tap { |qty_hash|
        vendor_qty = item[:columns][vendor_field]
        warehouse_qty = item[:columns][warehouse_field]

        if vendor_qty
          qty_hash[:vendor] = vendor_qty.to_i
        end
        if warehouse_qty
          qty_hash[:warehouse] = warehouse_qty.to_i
        end
      }.to_json
    end

    def get(identifier)
      json_hash = namespace.get(identifier)
      JSON.parse(json_hash) if json_hash
    end

    def delete(identifier)
      namespace.del(identifier)
    end

    private

    def namespace
      Redis::Namespace.new(Config.cache_namespace, redis: redis_connection)
    end

    def redis_connection
      @connection ||= Redis.new(host: Config.redis_host, port: Config.redis_port)
    end

    def vendor_field
      Config.netsuite_vendor_quantity_field
    end

    def warehouse_field
      Config.netsuite_warehouse_quantity_field
    end

  end

end
