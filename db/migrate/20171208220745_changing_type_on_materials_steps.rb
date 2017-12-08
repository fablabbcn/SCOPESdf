class ChangingTypeOnMaterialsSteps < ActiveRecord::Migration[5.0]
  def change
    remove_column :steps, :materials
    add_column :steps, :materials, :string, array: true, default: []
  end
end
