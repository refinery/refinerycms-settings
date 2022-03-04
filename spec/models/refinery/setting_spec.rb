require 'spec_helper'

module Refinery
  describe Setting, :type => :model do

    before do
      ::Refinery::Setting.set(:creating_from_scratch, nil)
      ::Refinery::Setting.set(:rspec_testing_creating_from_scratch, nil)
    end

    describe "slug" do
      it "creates a slug" do
        ::Refinery::Setting.set('test/something', {:value => "Look, a value"})
        expect(::Refinery::Setting.last.to_param).to eq('test-something')
      end
    end

    describe "set" do
      it "saves and gets @keram" do
        ::Refinery::Setting.find_or_set(:twitter, '@keram')
        setting = ::Refinery::Setting.last
        expect(setting.value).to eq('@keram')
      end

      it "does not strip whitespaces" do
        ::Refinery::Setting.find_or_set(:author, ' benbruscella ')
        setting = ::Refinery::Setting.last
        expect(setting.value).to eq(' benbruscella ')
      end

      it "creates a new setting if there isn't one" do
        expect(::Refinery::Setting.get(:creating_from_scratch, :scoping => 'rspec_testing')).to eq(nil)
        expect(::Refinery::Setting.set(:creating_from_scratch, {:value => "Look, a value", :scoping => 'rspec_testing'})).to eq("Look, a value")
      end

      it "overrides an existing setting" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "a value", :scoping => 'rspec_testing'})
        expect(set).to eq("a value")

        new_set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "newer replaced value", :scoping => 'rspec_testing'})
        expect(new_set).to eq("newer replaced value")
      end

      it "defaults to form_value_type text_area" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "a value", :scoping => 'rspec_testing'})
        expect(::Refinery::Setting.find_by(:name => 'creating_from_scratch', :scoping => 'rspec_testing').form_value_type).to eq("text_area")
      end

      it "fixes true as a value to 'true' (string)" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => true, :scoping => 'rspec_testing'})
        expect(::Refinery::Setting.find_by(:name => 'creating_from_scratch', :scoping => 'rspec_testing')[:value]).to eq('true')
        expect(set).to eq(true)
      end

      it "fixes false as a value to 'false' (string)" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => false, :scoping => 'rspec_testing'})
        expect(::Refinery::Setting.find_by(:name => 'creating_from_scratch', :scoping => 'rspec_testing')[:value]).to eq('false')
        expect(set).to eq(false)
      end

      it "sets '1' as the value of a check_box form_value_type to true" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "1", :scoping => 'rspec_testing', :form_value_type => 'check_box'})
        expect(::Refinery::Setting.find_by(:name => 'creating_from_scratch', :scoping => 'rspec_testing')[:value]).to eq('true')
        expect(set).to eq(true)
      end

      it "sets '0' as the value of a check_box form_value_type to false" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "0", :scoping => 'rspec_testing', :form_value_type => 'check_box'})
        expect(::Refinery::Setting.find_by(:name => 'creating_from_scratch', :scoping => 'rspec_testing')[:value]).to eq('false')
        expect(set).to eq(false)
      end
    end

    describe "get" do
      it "should retrieve a setting that was created" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "some value", :scoping => 'rspec_testing'})
        expect(set).to eq('some value')

        get = ::Refinery::Setting.get(:creating_from_scratch, :scoping => 'rspec_testing')
        expect(get).to eq('some value')
      end

      it "should also work with setting scoping using string and getting via symbol" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "some value", :scoping => 'rspec_testing'})
        expect(set).to eq('some value')

        get = ::Refinery::Setting.get(:creating_from_scratch, :scoping => :rspec_testing)
        expect(get).to eq('some value')
      end

      it "should also work with setting scoping using symbol and getting via string" do
        set = ::Refinery::Setting.set(:creating_from_scratch, {:value => "some value", :scoping => :rspec_testing})
        expect(set).to eq('some value')

        get = ::Refinery::Setting.get(:creating_from_scratch, :scoping => 'rspec_testing')
        expect(get).to eq('some value')
      end
    end

    describe "find_or_set" do
      it "will create a setting if it does not exist" do
        created = ::Refinery::Setting.find_or_set(:creating_from_scratch, 'I am a setting being created', :scoping => 'rspec_testing')

        expect(created).to eq("I am a setting being created")
      end

      it "will not override an existing setting" do
        created = ::Refinery::Setting.set(:creating_from_scratch, {:value => 'I am a setting being created', :scoping => 'rspec_testing'})
        expect(created).to eq("I am a setting being created")

        find_or_set_created = ::Refinery::Setting.find_or_set(:creating_from_scratch, 'Trying to change an existing value', :scoping => 'rspec_testing')

        expect(created).to eq("I am a setting being created")
      end

      it "works without scoping" do
        expect(::Refinery::Setting.find_or_set(:rspec_testing_creating_from_scratch, 'Yes it worked')).to eq('Yes it worked')
      end
    end

    describe "#should_generate_new_friendly_id?" do
      context "when name changes" do
        it "regenerates slug upon save" do
          setting = FactoryBot.create(:setting, :name => "Test Name")

          setting.name = "Test Name 2"
          setting.save!

          expect(setting.slug).to eq("test-name-2")
        end
      end
    end
  end
end
