module BeanCounter

  Config.option :cache_namespace, default: 'bean-counter'
  Config.option :redis_host,      default: '127.0.0.1'
  Config.option :redis_port,      default: '6379'

  Config.option :log_path
  Config.option :log_level,  default: :error
  Config.option :log_count,  default: 10
  Config.option :log_size,   default: 1048576

  Config.option :netsuite_account_id
  Config.option :netsuite_login
  Config.option :netsuite_password
  Config.option :netsuite_role_id
  Config.option :netsuite_searches, default: {}

  Config.option :netsuite_vendor_quantity_field,    default: :custitem22
  Config.option :netsuite_warehouse_quantity_field, default: :quantityavailable

end
