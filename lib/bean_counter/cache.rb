 module BeanCounter

   module Cache

     extend self

     def record(search_name)
       shift_to_cache(NetsuiteToolbox.public_send("#{search_name}_search"))
     end

     def shift_to_cache(items_to_cache)
       items_to_cache.each do |item|
         write_to_cache format_item(item)
       end
     end

     def write_to_cache(item)
       namespace[item.identifier] = item.value
     end

     def format_item(item)
       Config.cache_formatter.format(item)
     end

     def values_for(identifier)
       namespace[identifier]
     end

     def namespace
       @namespace ||= Redis::Namespace.new(Config.cache_namespace)
     end

   end

 end
