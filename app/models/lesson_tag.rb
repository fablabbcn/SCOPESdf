# == Schema Information
#
# Table name: lesson_tags
#
#  id            :integer          not null, primary key
#  taggable_id   :uuid             not null
#  taggable_type :integer          not null
#  lesson_id     :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class LessonTag < ApplicationRecord
  # TODO - think about adding assessment to here
  # TODO - think about adding difficulty to here


end
