class AddArraysOnLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :key_concepts, :string, array: true, default: []
    add_column :lessons, :key_vocabularies, :string, array: true, default: []
    add_column :lessons, :key_formulas, :string, array: true, default: []
  end
end
