# == Schema Information
#
# Table name: skills
#
#  id   :integer          not null, primary key
#  name :string           not null
#

class Skill < ApplicationRecord
  validates_uniqueness_of :name # CASE SENSITIVE todo - figure out a better way to handle this

  has_many :skill_tags


  def self.seed
    ["CNC", "Software", "CAD Design", "3D Printing", "Handywork", "Electrical"].map{ |s|
      new(name: s).save
    }
  end

end
