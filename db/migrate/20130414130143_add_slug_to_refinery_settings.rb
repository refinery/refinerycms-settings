class AddSlugToRefinerySettings < ActiveRecord::Migration[4.2]
  def change
    add_column :refinery_settings, :slug, :string, :unique => true
  end
end
