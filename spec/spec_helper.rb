# Set gem root directory
ROOT = File.expand_path(File.join('..', '..'), __FILE__)

# Require spec support files
Dir[File.join(ROOT, 'spec', 'support', '**', '*.rb')].each { |file| require file }

# Set load path for the gem itself
$LOAD_PATH.unshift(File.expand_path(ROOT))

require 'bean_counter'
require 'pry'

RSpec.configure do |config|
  config.mock_with :rspec

  config.before do
    BeanCounter::Config.netsuite_account_id = 'fake'
    BeanCounter::Config.netsuite_login      = 'fake'
    BeanCounter::Config.netsuite_password   = 'fake'
    BeanCounter::Config.netsuite_role_id    = 'fake'

    BeanCounter::Config.netsuite_searches[:test] = '1234'
  end
end
