 module BeanCounter

   module ItemCache

     extend self

     def record_recent
       shift_to_cache(NetsuiteToolbox.recently_changed_items)
     end

     def record_all
       shift_to_cache(NetsuiteToolbox.all_items)
     end

   end

 end
