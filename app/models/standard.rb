# == Schema Information
#
# Table name: standards
#
#  id           :uuid             not null, primary key
#  name         :string           not null
#  autocomplete :string
#

class Standard < ApplicationRecord
  has_and_belongs_to_many :lessons

  def self.seed

  end

  private
  def self.seed_values
  end

end
