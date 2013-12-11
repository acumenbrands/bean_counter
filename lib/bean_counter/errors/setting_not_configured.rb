module BeanCounter

  module Errors

    class SettingNotConfigured < BeanCountingError

      def initialize(method_name)
        super("No value has been specified for \"#{method_name}\"")
      end

    end

  end

end
