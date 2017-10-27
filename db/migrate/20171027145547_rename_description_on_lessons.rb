class RenameDescriptionOnLessons < ActiveRecord::Migration[5.0]
  def change
    rename_column :lessons, :description, :teacher_notes
  end
end
l