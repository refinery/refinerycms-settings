module Refinery
  class SettingsGenerator < Rails::Generators::Base

    def rake_db
      rake("refinery_settings:install:migrations")
    end

  end
end
