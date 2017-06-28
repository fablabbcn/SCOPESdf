# == Schema Information
#
# Table name: lessons
#
#  id                  :uuid             not null, primary key
#  name                :string           not null
#  topline             :string           default(""), not null
#  summary             :string           default(""), not null
#  learning_objectives :string           is an Array
#  description         :string           default(""), not null
#  assessment_criteria :string           default(""), not null
#  further_readings    :string           is an Array
#  difficulty_level    :integer
#  license             :integer          default(0), not null
#  outcome_links       :string           is an Array
#  original_lesson     :uuid
#  state               :integer          default("draft"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Lesson < ApplicationRecord

  # TODO - validate existence of user from lesson_tags
  # TODO - validate existence of organization from lesson_tags

  # TODO - validate against second page of form.... ie lesson_tags




  # Content ****************

  def totalDuration
    sum = 0
    self.steps.map{|x| sum += x.duration}
    sum
  end


  has_many :steps
  has_many :lesson_tags

  # TODO - search for filter on lesson_tags

  def addAuthor!(user_uuid)
    u = User.find(user_uuid)
    self.lesson_tags << LessonTag.new(taggable: u)
    # tag.author!
  end
  def addOrganization!(organization_uuid)
    tag = LessonTag.new(taggable_id: user_uuid, lesson_id: self.id)
    # tag.organization!
  end

  def setTeachingRange(start_range, end_range)
    return false if start_range > end_range #needed to handle higher... :(
    self.lesson_tags.where(taggable_type: "TeachingRange").map{|x| x.destroy}
    TeachingRange.setRangesForLesson(self.id, start_range, end_range)
  end
  def getTeachingRange
    range = self.lesson_tags.where(taggable_type: "TeachingRange").first.taggable
    {range_start: range.range_start, range_end: range.range_end}
  end


  def setSubject(subject)
    Subject.setSubjectForLesson(self.id, subject)
  end
  def getSubjects
    self.lesson_tags.where(taggable_type: "Subject").map{|x| y = x.taggable; y.name}
  end


  enum state: [:hidden, :draft, :visible]


  # todo - make search ( for visible only )

  # todo - add accessors to all of the children



end
