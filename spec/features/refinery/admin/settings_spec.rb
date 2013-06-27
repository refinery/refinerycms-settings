require "spec_helper"

module Refinery
  module Admin
    describe "Settings" do
      refinery_login_with :refinery_user

      context "when interface config is enabled" do
        before do
          Refinery::Settings.stub(:enable_interface).and_return(true)
        end

        it "shows up in menu" do
          visit refinery.admin_root_path

          within('nav') do
            page.should have_content "Settings"
          end
        end

        context "when no settings" do
          before { Refinery::Setting.destroy_all }

          it "invites to create one" do
            visit refinery.admin_settings_path
            page.should have_content("There are no settings yet. Click 'Add new setting' to add your first setting.")
          end
        end

        it "shows add new setting link" do
          visit refinery.admin_settings_path
          page.should have_content("Add new setting")
          page.should have_selector("a[href*='/refinery/settings/new']")
        end

        context "new/create" do
          it "adds setting", :js => true do
            visit refinery.admin_settings_path
            click_link "Add new setting"

            page.should have_selector('iframe#dialog_iframe')

            page.within_frame('dialog_iframe') do
              fill_in "setting_name", :with => "test setting"
              fill_in "setting_value", :with => "true"

              click_button "submit_button"
            end

            page.should have_content("'Test Setting' was successfully added.")
            page.should have_content("Test Setting - true")
          end

          it "adds setting with slug unfriendly name", :js => true do
            visit refinery.admin_settings_path
            click_link "Add new setting"

            page.should have_selector('iframe#dialog_iframe')

            page.within_frame('dialog_iframe') do
              fill_in "setting_name", :with => "Test/Setting"
              fill_in "setting_value", :with => "true"

              click_button "submit_button"
            end

            page.should have_content("'Test/Setting' was successfully added.")
            page.should have_content("Test/Setting - true")

            visit refinery.edit_admin_setting_path(Refinery::Setting.last)
            page.should_not have_content('NoMethodError in Refinery::Admin::BaseController#error_404')
          end
        end

        context "pagination" do
          before do
            (Refinery::Setting.per_page + 1).times do
              FactoryGirl.create(:setting)
            end
          end

          specify "page links" do
            visit refinery.admin_settings_path

            page.should have_selector("a[href*='settings?page=2']")
          end
        end
      end

      context "when interface config is disabled" do
        before do
          Refinery::Settings.stub(:enable_interface).and_return(false)
          Refinery::Plugins.registered.find_by_name("refinery_settings").hide_from_menu = true
        end

        it "does not show up in menu" do
          visit refinery.admin_root_path

          within('nav') do
            page.should_not have_content "Settings"
          end
        end
      end


    end
  end
end
