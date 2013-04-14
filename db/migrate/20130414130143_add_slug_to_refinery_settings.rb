class AddSlugToRefinerySettings < ActiveRecord::Migration
  def change
    add_column :refinery_settings, :slug, :string, :unique => true
  end
end
