# == Schema Information
#
# Table name: lessons_standards
#
#  lesson_id   :uuid             not null
#  standard_id :uuid             not null
#  description :string
#  index       :integer
#

class LessonsStandard < ApplicationRecord
  belongs_to :lesson
  belongs_to :standard

end
