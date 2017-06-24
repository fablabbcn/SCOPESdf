# == Schema Information
#
# Table name: teaching_ranges
#
#  id          :uuid             not null, primary key
#  range_start :integer          default(0), not null
#  range_end   :integer          default(0), not null
#

class TeachingRange < ApplicationRecord
end
