require 'spec_helper'

describe "Refinery::Settings", type: :routing do
 context 'when interface disabled' do
    it "is not routable" do
      allow(Refinery::Settings).to receive(:enable_interface).and_return(false)
      expect(get: "/refinery/settings").to not_be_routable
    end
 end

 context 'when interface enabled' do
   it "routes to the settings index" do
     allow(Refinery::Settings).to receive(:enable_interface).and_return(true)
     expect(get: "/refinery/settings").to be_routable
   end
 end
end
