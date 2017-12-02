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

  STATIC_INVOLVEMENTS = ["classroom teacher", "maker / fabber", "youth",
                         "cirriculum developer", "informal educator",
                         "volunteer", "makerspace staff"]

  def downcase_name
    self.name = self.name.downcase
  end

  def self.seed
    STATIC_INVOLVEMENTS.each { |involvement| create(name: involvement) }
  end

end
