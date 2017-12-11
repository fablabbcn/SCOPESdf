class LessonsStandardsDescriptionToArray < ActiveRecord::Migration[5.0]
  def change
    remove_column :lessons_standards, :description
    add_column :lessons_standards, :description, :string, array: true, default: []
  end
end
