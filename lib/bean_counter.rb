require 'logger'
require 'netsuite-rest-client'
require 'redis-namespace'

require_relative 'bean_counter/errors/bean_counting_error'
require_relative 'bean_counter/errors/setting_not_configured'

require_relative 'bean_counter/config/options'
require_relative 'bean_counter/config'

require_relative 'bean_counter/logging'
require_relative 'bean_counter/netsuite_toolbox'
require_relative 'bean_counter/item_cache'

require_relative 'bean_counter/version'

module BeanCounter

  extend self
  extend Logging

  Config.option :log_path
  Config.option :log_level,  default: :error
  Config.option :log_count,  default: 10
  Config.option :log_size,   default: 1048576

  Config.option :netsuite_account_id
  Config.option :netsuite_login
  Config.option :netsuite_password
  Config.option :netsuite_role_id
  Config.option :netsuite_search_id_recent_items
  Config.option :netsuite_search_id_all_items

  def load!(path)
    Config.load!(path)
  end

  def configure(&block)
    block_given? ? yield(Config) : Config
  end

  def poll_recent
    ItemCache.record_recent
  end

  def poll_all
    ItemCache.record_all
  end

  def record
    Storage.update_from_cache
  end

end

require_relative 'bean_counter/railtie' if defined?(Rails)
