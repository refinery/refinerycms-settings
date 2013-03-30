require 'refinerycms-core'

module Refinery
  autoload :SettingsGenerator, 'generators/refinery/settings_generator'

  module Settings

    require 'refinery/settings/engine'
    require 'refinery/settings/configuration'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec/factories').to_s ]
      end
    end
  end
end
