class AddTitleToRefinerySettings < ActiveRecord::Migration[4.2]
  def change
    add_column :refinery_settings, :title, :string
  end
end
