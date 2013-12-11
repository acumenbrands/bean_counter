require 'bean_counter'

module Rails

  module BeanCounter

    class Railtie < Rails::Railtie

      def self.generator
        config.respond_to?(:app_generators) ? :app_generators : :generators
      end

      def self.rescue_responses
        { BeanCounter::Errors::FileNotFound => :not_found }
      end

      def handle_configuration_error(error)
        puts "There is a configuration error with bean_counter.yml"
        puts error.message
      end

      if config.action_dispatch.rescue_responses
        config.action_dispatch.rescue_responses.merge!(rescue_responses)
      end

      rake_tasks do
        load "bean_counter/railties/bean_counter_rails.rake"
      end

      config.bean_counter = ::BeanCounter::Config

      initializer "bean_counter.configure" do
        config_file = Rails.root.join('config', 'bean_counter.yml')

        if config_file.file?
          ::BeanCounter.load!(config_file)
        end
      end

      config.after_initialize do
        unless config.action_dispatch.rescue_responses
          ActionDispatch::ShowExceptions.rescue_responses.update(Railtie.rescue_responses)
        end
      end

    end

  end

end
