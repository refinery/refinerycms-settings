module Refinery
  module Settings
    include ActiveSupport::Configurable

    config_accessor :enable_interface

    self.enable_interface = true
  end
end