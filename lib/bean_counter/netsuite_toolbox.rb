module BeanCounter

  module NetsuiteToolbox

    extend self

    SEARCH_RECORD_TYPE = 'inventoryitem'
    SEARCH_BATCH_SIZE  = 1000

    def add_search(name, id)
      Config.netsuite_searches[name] = id
    rescue NoMethodError
      raise Errors::SearchIdSetNotAHash.new
    end

    def search(name, start_id)
      get_search_results(search_id(name), start_id)
    end

    def get_search_results(search_id, start_id)
      client.get_saved_search(
        SEARCH_RECORD_TYPE, search_id,
        start_id:               start_id,
        exit_after_first_batch: true,
        search_batch_size:      SEARCH_BATCH_SIZE
      )
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
