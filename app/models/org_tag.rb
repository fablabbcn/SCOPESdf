# == Schema Information
#
# Table name: org_tags
#
#  id              :integer          not null, primary key
#  taggable_id     :uuid             not null
#  taggable_type   :string           not null
#  organization_id :uuid             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OrgTag < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  validates :taggable_id, presence: true
  validates :taggable_type, presence: true

  validates :organization_id, presence: true

  validates_uniqueness_of :taggable_id, :scope => [:taggable_type, :organization_id]

  # Currently links to the following:
  #

end
