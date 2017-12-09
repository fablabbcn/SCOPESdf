class AddDurationToLesson < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :duration, :string
  end
end
