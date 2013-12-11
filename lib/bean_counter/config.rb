module BeanCounter

  module Config

    extend self
    extend Options

    # General Settings
    option :log_level

    # Netsuite Settings
    option :netsuite_account_id
    option :netsuite_login
    option :netsuite_password
    option :netsuite_role_id

    # Storage Settings

    def load!(path)
      options = load_yaml(path) if settings
    end

    def options=(options)
      if options
        options.each_pair do |option, value|
          public_send("#{option}=", value)
        end
      end
    end

  end

end
