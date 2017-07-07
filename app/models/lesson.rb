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
#  license             :integer          default(0), not null
#  outcome_links       :string           is an Array
#  original_lesson     :uuid
#  state               :integer          default("draft"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Lesson < ApplicationRecord
  enum state: [:hidden, :draft, :visible]


  # TODO - validate publishing only when all content is set

  # TODO - api view sections for content loading

  # TODO - top right buttons..
  # TODO - activity feed == history of lesson_tags

  # TODO - assessment criteria - input field and file format... ( assessment_criteria_docs :: JSON )


  #   validates :author_exists
  def author_exists         # TODO - validate existence of user from lesson_tags
    # not saved yet... so checking against query doesn't work *
  end
  #   validates :organization_exists
  def organization_exists   # TODO - validate existence of organization from lesson_tags
    # not saved yet... so checking against query doesn't work *
  end



  def totalDuration
    sum = 0
    self.steps.map{|x| sum += x.duration}
    sum
  end


  has_many :steps
  has_many :lesson_tags, dependent: :destroy

  # TODO - search for filter on lesson_tags


  def addAuthor(user_uuid)
    u = User.find(user_uuid)
    self.lesson_tags << LessonTag.new(taggable: u)
  end
  def getAuthors_id
    self.lesson_tags.where(taggable_type: "User").map{|x| y = x.taggable; y.id}
  end
  def getAuthors
    self.lesson_tags.where(taggable_type: "User").map{|x| y = x.taggable; y}
  end
  def removeAuthor(user_uuid)
    self.lesson_tags.where(taggable_type: "User", taggable_id: user_uuid).destroy_all
  end


  def addOrg(organization_uuid)
    x = Organization.find(organization_uuid)
    self.lesson_tags << LessonTag.new(taggable: x)
  end
  def getOrgs_id
    self.lesson_tags.where(taggable_type: "Organization").map{|x| y = x.taggable; y.id}
  end
  def removeOrg(organization_uuid)
    self.lesson_tags.where(taggable_type: "Organization", taggable_id: organization_uuid).destroy_all
  end



  def setTeachingRange(start_range, end_range)
    return false if start_range > end_range             #needed to handle higher...  in call stack :(
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
  def getSubjects_name
    self.lesson_tags.where(taggable_type: "Subject").map{|x| y = x.taggable; y.name}
  end




  # Likes
  def setLike(user_uuid)
    u = User.find(user_uuid)
    Like.new(user_id: u.id, lesson_id: self.id).save
  end
  def getLikes_obj
    Like.where(lesson_id: self.id)
  end
  def getLikes_id
    getLikes_obj.map{|x| x.user_id}
  end
  def getLikes_users
    User.where(id: getLikes_id)
  end
  def removeLike(user_uuid)
    u = User.find(user_uuid)
    Like.where(user_id: u.id, lesson_id: self.id).destroy_all
  end




  # todo - make search ( for visible only )

  # todo - add accessors to all of the children

  def furtherReadings_data
    self.further_readings.map{ |x|
      begin
        lt = LinkThumbnailer.generate(x)
        image = VideoThumb::get(x)
        image ||= lt.images.first.src.to_s
        { url: x, title: lt.title, description: lt.description, thumnail: image }
      rescue LinkThumbnailer::Exceptions => e
        { url: x }
      end
    }
  end


end
