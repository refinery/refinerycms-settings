class AddTitleToRefinerySettings < ActiveRecord::Migration
  def change
    add_column :refinery_settings, :title, :string
  end
end
