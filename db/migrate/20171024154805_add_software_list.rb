class AddSoftwareList < ActiveRecord::Migration[5.0]
  def change
    add_column :steps, :software, :string, array: true, default: []
  end
end
