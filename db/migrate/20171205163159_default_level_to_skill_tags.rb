class DefaultLevelToSkillTags < ActiveRecord::Migration[5.0]
  def change
    change_column :skill_tags, :level, :integer, default: 0, null: false
  end
end
