module BeanCounter

  module NetsuiteToolbox

    extend self

    SEARCH_RECORD_TYPE = 'inventoryitem'

    def add_search(name, id)
      Config.netsuite_searches[name] = id
    rescue NoMethodError
      raise Errors::SearchIdSetNotAHash.new
    end

    def get_search_results(search_id)
      client.get_saved_search(SEARCH_RECORD_TYPE, search_id)
    end

    def method_missing(method, *args, &block)
      if method =~ /_search$/
        search_name = method.to_s.gsub(/_search$/,'').to_sym
        search_id   = search_id(search_name)
        get_search_results(search_id)
      else
        super
      end
    end

    def client
      Netsuite::Client.new(
        Config.netsuite_account_id,
        Config.netsuite_login,
        Config.netsuite_password,
        Config.netsuite_role_id
      )
    end

    private

    def search_id(search_name)
      Config.netsuite_searches.fetch(search_name)
    rescue KeyError
      raise Errors::SearchIdDoesNotExist.new(search_name)
    rescue NoMethodError
      raise Errors::SearchIdSetNotAHash.new
    end

  end

end
