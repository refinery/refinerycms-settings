module Refinery
  module Settings
    class Engine < ::Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_settings

      config.autoload_paths += %W( #{config.root}/lib )

      initializer "register refinery_settings plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_settings'
          plugin.menu_match = %r{refinery/settings$}
          plugin.hide_from_menu = !Refinery::Settings.enable_interface
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.admin_settings_path }
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Settings)
      end
    end
  end
end
