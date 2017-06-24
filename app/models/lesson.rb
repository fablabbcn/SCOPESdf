# == Schema Information
#
# Table name: lessons
#
#  id                  :uuid             not null, primary key
#  name                :string           not null
#  topline             :string           default(""), not null
#  summary             :string           default(""), not null
#  learning_objectives :json
#  description         :string           default(""), not null
#  assessment_criteria :string           default(""), not null
#  further_readings    :json
#  difficulty_level    :integer
#  outcome_links       :json
#  original_lesson     :uuid
#  state               :integer          default("draft"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Lesson < ApplicationRecord

  # TODO - validate existence of user from lesson_tags
  # TODO - validate existence of organization from lesson_tags

  # TODO - validate against second page of form.... ie lesson_tags

  # TODO - validate at least one step!


  def getTotalDuration
    # TODO - show duration from adding up all of the steps!
  end


  has_many :steps

  enum state: [:hidden, :draft, :visible]


  # todo - make search ( for visible only )



end
