require "spec_helper"


describe "routes for refinery settings", :type => :routing do

  context "when interface config is disabled" do
    before do
      allow(Refinery::Settings).to receive(:enable_interface).and_return(false)
      Refinery::Plugins.registered.find_by_name("refinery_settings").hide_from_menu = true
    end

    it "should not be accesible" do
      expect(:get => "/refinery/settings").to_not be_routable
    end
  end
end
