# == Schema Information
#
# Table name: affiliations
#
#  id              :integer          not null, primary key
#  user_id         :uuid             not null
#  organization_id :uuid             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Affiliation < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  # TODO - validates uniqueness on compound key?.. should add?
end
