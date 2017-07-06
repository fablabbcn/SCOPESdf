# == Schema Information
#
# Table name: skill_tags
#
#  id            :integer          not null, primary key
#  taggable_id   :uuid             not null
#  taggable_type :string           not null
#  skill_id      :integer          not null
#  level         :integer          not null
#

class SkillTag < ApplicationRecord

end
