# == Schema Information
#
# Table name: user_tags
#
#  id            :integer          not null, primary key
#  taggable_id   :uuid             not null
#  taggable_type :string           not null
#  user_id       :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class UserTag < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  validates :taggable_id, presence: true
  validates :taggable_type, presence: true

  validates :user_id, presence: true

  validates_uniqueness_of :taggable_id, :scope => [:taggable_type, :user_id]

  # Currently links to the following:
  # Involvement
  # Subject
  # OtherInterests

end
