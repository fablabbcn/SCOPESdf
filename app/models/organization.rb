# == Schema Information
#
# Table name: organizations
#
#  id                   :uuid             not null, primary key
#  name                 :string           default(""), not null
#  desc                 :string           default(""), not null
#  social               :json
#  teaching_range_start :integer          default(0), not null
#  teaching_range_end   :integer          default(0), not null
#  address_line1        :string
#  address_line2        :string
#  address_line3        :string
#  address_line4        :string
#  locality             :string
#  region               :string
#  post_code            :string
#  country              :string
#  lonlat               :geography({:srid not null, point, 4326
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Organization < ApplicationRecord
  enum teaching_range_start:  [:start_k, :start_grade_1, :start_grade_2, :start_grade_3,
            :start_grade_4, :start_grade_5,
            :start_grade_6, :start_grade_7, :start_grade_8,
            :start_grade_9, :start_grade_10, :start_grade_11, :start_grade_12 ]

  enum teaching_range_end: [:end_k, :end_grade_1, :end_grade_2, :end_grade_3,
            :end_grade_4, :end_grade_5,
            :end_grade_6, :end_grade_7, :end_grade_8,
            :end_grade_9, :end_grade_10, :end_grade_11, :end_grade_12 ]


  has_many :affiliations
  has_many :users, through: :affiliations

  # TODO - add validations
  # TODO - check lonlat is real**  or handle...
  # TODO - make some address fields required?
  # TODO - add creating user
  # TODO - add pending_confirmation
  # TODO - add confirmed_date
  # TODO - add confirmed_user
  # TODO - add flagged? to report

  def self.withId_(id)
    Option(Organization.find_by(id: id))
  end

  def self.withPoints(lon,lat)
    Review.where(lonlat: RGeo::Cartesian.factory.point(lon,lat))
  end

  def self.getRangeByCurrent(range, currentlon, currentlat)
    Review.where("ST_Distance(lonlat, 'POINT(#{currentlon} #{currentlat})') < #{range}")
  end

# ~~~~~~~~~~~~

  def setPoints(lon,lat)
    self.lonlat = RGeo::Cartesian.factory.point(lon,lat)
    self
  end

end