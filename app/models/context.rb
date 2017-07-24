# == Schema Information
#
# Table name: contexts
#
#  id   :uuid             not null, primary key
#  name :string           not null
#

class Context < ApplicationRecord
  has_many :lesson_tags, as: :taggable

  validates_uniqueness_of :name

  before_create :downcase_name, :if => :new_record?

  def downcase_name
    self.name = self.name.downcase
  end

  def self.seed
    ["in classroom", "in fablab", "capstone", "group", "homework", "other"].map{ |i|
      new(name: i).save
    }
  end
end
