# Bean Counter

Release: 1.3

An Acumen Holdings gem for fetching and using inventory data from Netsuite

## Installation

Just add the gem to your project's Gemfile:

````ruby
gem 'bean_counter', git: 'git@github.com:acumenbrands/bean_counter.git', tag: '1.3'
````

## Configuration

Bean counter can either be configured at runtime or via a YAML file. If it is included in a Rails project, it will automatically attempt to configure itself from `config/bean_counter.yml`.

All settings can be configured at runtime by accessing the config namespace; either directly or via the configure call with a block.

````ruby
# directly
BeanCounter::Config.cache_namespace = 'an-example-namespace'

# configure
BeanCounter.configure do |config|
  config.cache_namespace = 'an-example-namespace'
end
````

### Settings

* cache_namespace: This is the string that will be prepended to all redis keys
* log_path: The string path to the log file to be used (Rails defaults to the rails logger instead)
* log_level: Symbol for the default logger level (default: :error)
* log_count: Max count of log files (default: 10)
* log_size: Maximum size of the log files before a new file is created (default: 1048576)
* netsuite_account_id: The account id for Netsuite access
* netsuite_login: The login to be used for Netsuite access
* netsuite_password: The password to be used for Netsuite access
* netsuite_role_id: The role id to be used for Netsuite access
* netsuite_searches: A hash of netsuite search ids (detailed below)
* netsuite_vendor_quantity_field: Symbol of the vendor quantity field (default: custitem22)
* netsuite_warehouse_quantity_field: Symbol of the warehouse quantity field (default: :quantityavailable)

## Netsuite Searches

Netsuite searches are stores as a hash of names => ids. A convenience method on BeanCounter::NetsuiteToolbox exists for adding searches at runtime.

````ruby
# example YAML
netsuite_searches:
  :example_search: '123'
  :other_search:   '456'

# via convenience method
BeanCounter::NetsuiteToolbox.add_search(:example_search, '123')
BeanCounter::NetsuiteToolbox.add_search(:other_search, '456')

# complete override
BeanCounter::Config.netsuite_searches = {
  example_search: '123',
  other_search:   '456'
}
````

## Caching a Search

To execute and cache the results of a search in Redis:

````ruby
BeanCounter.cache_search(:search_name)
````

## Using Search Data

Bean Counter provides a class called BeanCounter::Bean to track the relationship between and item and its inventory data. To use it, in your application you will need to implement two things:

* identifier_names: This should return an Array of Symbols that match method names which provide a sku and upc
* update_from_cache: This should return true if an update was successful, false if an update was not

### Example of a Simple Honest Engine Decorator

````ruby
class HonestBean < BeanCounter::Bean

  def identifier_names
    [:upc_code, :sku_with_vendor]
  end

  def update_from_cache
    target.update_attributes(new_attributes)
    true
  rescue Exception => e # Don't actually do this, this is just a simple example
    false
  end

end
````
