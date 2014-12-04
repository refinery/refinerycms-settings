require "spec_helper"

module Refinery
  module Admin
    describe "Settings", :type => :feature do
      refinery_login_with :refinery_user

      context "when interface config is enabled" do
        before do
          allow(Refinery::Settings).to receive(:enable_interface).and_return(true)
        end

        it "shows up in menu" do
          visit refinery.admin_root_path

          within('nav') do
            expect(page).to have_content "Settings"
          end
        end

        context "when no settings" do
          before { Refinery::Setting.destroy_all }

          it "invites to create one" do
            visit refinery.admin_settings_path
            expect(page).to have_content("There are no settings yet. Click 'Add new setting' to add your first setting.")
          end
        end

        it "shows add new setting link" do
          visit refinery.admin_settings_path
          expect(page).to have_content("Add new setting")
          expect(page).to have_selector("a[href*='/refinery/settings/new']")
        end

        context "new/create" do
          it "adds setting", :js => true do
            visit refinery.admin_settings_path
            click_link "Add new setting"

            expect(page).to have_selector('iframe#dialog_iframe')

            page.within_frame('dialog_iframe') do
              fill_in "setting_name", :with => "test setting"
              fill_in "setting_value", :with => "true"

              click_button "submit_button"
            end
            expect(page).not_to have_css("#dialog_iframe")
            expect(page).to have_content("'Test Setting' was successfully added.")
            expect(page).to have_content("Test Setting - true")
          end

          it "adds setting with slug unfriendly name", :js => true do
            visit refinery.admin_settings_path
            click_link "Add new setting"

            expect(page).to have_selector('iframe#dialog_iframe')

            page.within_frame('dialog_iframe') do
              fill_in "setting_name", :with => "Test/Setting"
              fill_in "setting_value", :with => "true"

              click_button "submit_button"
            end

            expect(page).to have_content("'Test/Setting' was successfully added.")
            expect(page).to have_content("Test/Setting - true")

            visit refinery.edit_admin_setting_path(Refinery::Setting.last)
            expect(page).not_to have_content('NoMethodError in Refinery::Admin::BaseController#error_404')
          end
        end

        context "edit/update" do
          before(:each) {::Refinery::Setting.set(:rspec_testing_edit_and_update, 1)}

          it "modifies setting", :js => true do
            visit refinery.admin_settings_path
            find("a[href*='/refinery/settings/rspec_testing_edit_and_update/edit']").click

            expect(page).to have_selector('iframe#dialog_iframe')
            page.within_frame('dialog_iframe') do

              expect(find_field('Title').value).to eql("Rspec Testing Edit And Update")

              fill_in "Title", :with => "Edit and Update Title"
              fill_in "Value", :with => "2"

              click_button "Save"
            end

            expect(page).to have_content("'Edit and Update Title' was successfully updated.")
            expect(page).to have_content("Edit and Update Title - 2")
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

            expect(page).to have_selector("a[href*='settings?page=2']")
          end
        end
      end

      context "when interface config is disabled" do
        before do
          allow(Refinery::Settings).to receive(:enable_interface).and_return(false)
          Refinery::Plugins.registered.find_by_name("refinery_settings").hide_from_menu = true
        end

        it "does not show up in menu" do
          visit refinery.admin_root_path

          within('nav') do
            expect(page).not_to have_content "Settings"
          end
        end
      end


    end
  end
end
