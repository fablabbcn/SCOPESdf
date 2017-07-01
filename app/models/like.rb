# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  lesson_id  :uuid             not null
#  user_id    :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Like < ApplicationRecord
  validates_uniqueness_of :lesson_id, :scope => [:user_id]
end
