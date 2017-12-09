class ChangeStandards < ActiveRecord::Migration[5.0]
  def change
    remove_column :standards, :autocomplete
    add_column :standards, :autocomplete, :string, array: true, default: []
  end
end
