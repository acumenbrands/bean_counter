module BeanCounter

  module NetsuiteToolbox

    extend self

    SEARCH_RECORD_TYPE = 'inventoryitem'

    Config.option :netsuite_account_id
    Config.option :netsuite_login
    Config.option :netsuite_password
    Config.option :netsuite_role_id
    Config.option :netsuite_search_id_recent_items
    Config.option :netsuite_search_id_all_items

    def recently_changed_items
      puts "Fetching records from Netsuite..."
      client.get_saved_search(SEARCH_RECORD_TYPE, Config.netsuite_search_id_recent_items)
    end

    def all_items
      client.get_saved_search(SEARCH_RECORD_TYPE, Config.netsuite_search_id_all_items)
    end

    def client
      Netsuite::Client.new(
        auth[:account_id],
        auth[:login],
        auth[:password],
        auth[:role_id]
      )
    end

    def auth
      {
        account_id: Config.netsuite_account_id,
        login:      Config.netsuite_login,
        password:   Config.netsuite_password,
        role_id:    Config.netsuite_role_id
      }
    end

  end

end
