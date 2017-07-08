# == Schema Information
#
# Table name: other_interests
#
#  id   :uuid             not null, primary key
#  name :string           not null
#

class OtherInterest < ApplicationRecord
  has_many :lesson_tags, as: :taggable
  has_many :user_tags, as: :taggable

  validates_uniqueness_of :name

  before_create :downcase_name, :if => :new_record?
  def downcase_name
    self.name = self.name.downcase
  end

end
