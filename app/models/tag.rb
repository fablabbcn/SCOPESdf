# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  taggable_id   :uuid             not null
#  taggable_type :integer          not null
#  lesson_type   :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Tag < ApplicationRecord
  enum taggable_type: [:user, :organization] # Tag types here # TODO  - add
  belongs_to :taggable, polymorphic: true
end
