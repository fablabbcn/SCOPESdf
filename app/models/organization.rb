# == Schema Information
#
# Table name: organizations
#
#  id            :uuid             not null, primary key
#  name          :string           default(""), not null
#  desc          :string           default(""), not null
#  social        :json
#  contact_email :string
#  state         :integer          default("unvalidated"), not null
#  address_line1 :string
#  address_line2 :string
#  address_line3 :string
#  address_line4 :string
#  locality      :string
#  region        :string
#  post_code     :string
#  country       :string
#  lonlat        :geography({:srid point, 4326
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Organization < ApplicationRecord
  enum state: [:unvalidated, :validated]

  has_many :affiliations, dependent: :destroy
  has_many :users, through: :affiliations
  # has_many :tags, as: :taggable

  # TODO - add validations
  # TODO - check lonlat is real**  or handle...
  # TODO - make some address fields required?
  # TODO - add pending_confirmation
  # TODO - add confirmed_date
  # TODO - add confirmed_user
  # TODO - add flagged? to report
  # TODO - ATTR: add active / inactive

  def self.withId_(id)
    Option(Organization.find_by(id: id))
  end

  def self.withPoints(lon,lat)
    Review.where(lonlat: RGeo::Cartesian.factory.point(lon,lat))
  end

  def self.getRangeByCurrent(range, currentlon, currentlat)
    Review.where("ST_Distance(lonlat, 'POINT(#{currentlon} #{currentlat})') < #{range}")
  end


  def associateWithLesson(lesson_id)
    l = Lesson.find(lesson_id)
    l.lesson_tags << LessonTag.new(taggable: self)
  end

# ~~~~~~~~~~~~

  def setPoints(lon,lat)
    self.lonlat = RGeo::Cartesian.factory.point(lon,lat)
    self
  end

end
