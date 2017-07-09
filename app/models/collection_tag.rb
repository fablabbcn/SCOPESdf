# == Schema Information
#
# Table name: collection_tags
#
#  id   :uuid             not null, primary key
#  name :string           not null
#

class CollectionTag < ApplicationRecord
  has_many :lesson_tags, as: :taggable

  validates_uniqueness_of :name

  before_create :downcase_name, :if => :new_record?

  def downcase_name
    self.name = self.name.downcase
  end

  def self.seed
    ["Gold Standard Lesson"].map{ |i|
      new(name: i).save!
    }
  end


end
