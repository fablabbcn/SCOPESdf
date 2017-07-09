# == Schema Information
#
# Table name: difficulty_levels
#
#  id     :uuid             not null, primary key
#  level  :integer          default("beginner"), not null
#  metric :integer          default("students"), not null
#

class DifficultyLevel < ApplicationRecord
  has_many :lesson_tags, as: :taggable

  enum level: [ :beginner, :intermediate, :advanced ]
  enum metric: [ :students, :educator ]

  validates_uniqueness_of :metric, :scope => :level

  def self.seed
    for i in 0..2 do
      for j in 0..1 do
        begin
          new(level: i, metric: j).save!
        rescue ActiveRecord::RecordInvalid => e
          next
        end
      end
    end
  end



end
