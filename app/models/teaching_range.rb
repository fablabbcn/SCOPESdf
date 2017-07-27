# == Schema Information
#
# Table name: teaching_ranges
#
#  id          :uuid             not null, primary key
#  range_start :integer          default("start_pre_k"), not null
#  range_end   :integer          default("end_pre_k"), not null
#

class TeachingRange < ApplicationRecord
  has_many :lesson_tags, as: :taggable

  enum range_start:  [:start_pre_k, :start_k, :start_grade_1, :start_grade_2, :start_grade_3,
                               :start_grade_4, :start_grade_5,
                               :start_grade_6, :start_grade_7, :start_grade_8,
                               :start_grade_9, :start_grade_10, :start_grade_11, :start_grade_12 ]

  enum range_end: [:end_pre_k, :end_k, :end_grade_1, :end_grade_2, :end_grade_3,
                            :end_grade_4, :end_grade_5,
                            :end_grade_6, :end_grade_7, :end_grade_8,
                            :end_grade_9, :end_grade_10, :end_grade_11, :end_grade_12 ]

  validates_uniqueness_of :range_end, :scope => :range_start

  def self.seed
    for i in 0..13 do
      for j in 0..13 do
        if (i < j)
          begin
            new(range_start: i, range_end: j).save!
          rescue ActiveRecord::RecordInvalid => e
            # do not make new
          end
        end
      end
    end
  end

  def self.inputRange
    {
        "0" => "pre-k",
        "1" => "k",
        "2" => "1st",
        "3" => "2nd",
        "4" => "3rd",
        "5" => "4th",
        "6" => "5th",
        "7" => "6h",
        "8" => "7th",
        "9" => "8th",
        "10" => "9th",
        "11" => "10th",
        "12" => "11th",
        "13" => "12th"
    }
  end

  def self.translate(value)
    if value.kind_of? String
      value = value.downcase
    end
    case
      when value == "pre-k"
        return 0
      when value == "k"
        return 1
      else
        return value.to_i + 1
    end
  end

  def self.setRangesForLesson(lesson_id, s, e)
    l = Lesson.find(lesson_id)
    r = self.where(range_start: translate(s) , range_end: translate(e)).first
    l.lesson_tags << LessonTag.new(taggable: r)
  end

  def self.format(value)
    case
      when value == "grade_1"
        return "1st"
      when value == "grade_2"
        return "2nd"
      when value == "grade_3"
        return "3rd"
      when value == "grade_4"
        return "4th"
      when value == "grade_5"
        return "5th"
      when value == "grade_6"
        return "6th"
      when value == "grade_7"
        return "7th"
      when value == "grade_8"
        return "8th"
      when value == "grade_9"
        return "9th"
      when value == "grade_10"
        return "10th"
      when value == "grade_11"
        return "11th"
      when value == "grade_12"
        return "12th"
      else
        return value
    end
  end


end
