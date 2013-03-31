Refinery::Core::Engine.routes.draw do
  if Refinery::Settings.enable_interface
    namespace :admin, :path => 'refinery' do
      resources :settings, :except => :show
    end
  end
end
