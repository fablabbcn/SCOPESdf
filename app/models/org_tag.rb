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



end
