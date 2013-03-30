module Refinery
  class SettingsGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def generate_settings_initializer
      template "config/initializers/refinery/settings.rb.erb", File.join(destination_root, "config", "initializers", "refinery", "settings.rb")
    end

    def rake_db
      rake("refinery_settings:install:migrations")
    end

  end
end
