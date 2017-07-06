# == Schema Information
#
# Table name: affiliations
#
#  id              :integer          not null, primary key
#  user_id         :uuid             not null
#  organization_id :uuid             not null
#  primary         :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Affiliation < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates_uniqueness_of :user_id, :scope => :organization_id

  # TODO - ATTR: add active / inactive

end
