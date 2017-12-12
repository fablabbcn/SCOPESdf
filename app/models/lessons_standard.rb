# == Schema Information
#
# Table name: lessons_standards
#
#  id          :uuid             not null, primary key
#  lesson_id   :uuid             not null
#  standard_id :uuid             not null
#  index       :integer
#  description :string           default([]), is an Array
#

class LessonsStandard < ApplicationRecord

  ## Associations
  belongs_to :lesson
  belongs_to :standard

  # Determines whether a new standard should be set up after saving
  attribute :new_after_save, :boolean

  before_save do
    self.description = self.description.reject {|x| x.empty?} if self.description.present?
  end

end
