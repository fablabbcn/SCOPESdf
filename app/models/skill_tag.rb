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

  attribute :level, :integer, default: 0

  belongs_to :taggable, polymorphic: true
  belongs_to :skill
  validates :taggable_id, presence: true
  validates :taggable_type, presence: true
  validates :skill_id, presence: true
  validates :level, presence: true

  validates_uniqueness_of :taggable_id, :scope => [:taggable_type, :skill_id]

  # Currently links to the following:
  #
  #

end
