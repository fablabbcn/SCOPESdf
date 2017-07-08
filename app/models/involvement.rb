# == Schema Information
#
# Table name: involvements
#
#  id   :uuid             not null, primary key
#  name :string           not null
#

class Involvement < ApplicationRecord
  has_many :user_tags, as: :taggable

  validates_uniqueness_of :name

  before_create :downcase_name, :if => :new_record?

  def downcase_name
    self.name = self.name.downcase
  end

  def self.seed
    ["classroom teacher", "maker / fabber", "youth", "cirriculum developer", "informal educator", "wolunteer", "makerspace staff"].map{ |i|
      new(name: i).save!
    }
  end

end
