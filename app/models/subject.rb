# == Schema Information
#
# Table name: subjects
#
#  id   :uuid             not null, primary key
#  name :string           not null
#

class Subject < ApplicationRecord
  has_many :lesson_tags, as: :taggable
  validates_uniqueness_of :name

  before_create :downcase_name, :if => :new_record?

  def downcase_name
    self.name = self.name.downcase
  end

  def self.setSubjectForLesson(lesson_id, s_str)
    l = Lesson.find(lesson_id)
    s = Subject.find_or_create_by(name: s_str)
    l.lesson_tags << LessonTag.new(taggable: s)
  end

  def self.removeSubjectForLesson(lesson_id, s_str)
    l = Lesson.find(lesson_id)
    l.getSubjects.map{|x| puts x}
  end
end
