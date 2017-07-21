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
    ["Fab Certified/Tested", "Big Ideas", "Games", "Environmental","World Culture","Chevron STEM Award"].map{ |i|
      new(name: i).save
    }
  end


end
