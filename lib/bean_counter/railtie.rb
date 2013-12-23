require 'bean_counter'

module BeanCounter

  class Railtie < Rails::Railtie

    def self.generator
      config.respond_to?(:app_generators) ? :app_generators : :generators
    end

    def handle_configuration_error(error)
      puts "There is a configuration error with bean_counter.yml"
      puts error.message
    end

    config.bean_counter = ::BeanCounter::Config

    initializer "bean_counter.configure" do
      ::BeanCounter::Logging.logger = Rails.logger

      config_file = Rails.root.join('config', 'bean_counter.yml')

      if config_file.file?
        ::BeanCounter.load!(config_file)
      end
    end

  end

end
