# == Schema Information
#
# Table name: steps
#
#  id                  :uuid             not null, primary key
#  lesson_id           :uuid             not null
#  name                :string           not null
#  summary             :string           default(""), not null
#  duration            :integer          default(0), not null
#  supporting_images   :json
#  materials           :json
#  tools               :json
#  supporting_material :json
#  step_number         :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Step < ApplicationRecord

  validates :lesson_id, presence: true
  validates :name, presence: true

  before_create :check_step_number, :if => :new_record?
  def check_step_number
    self.step_number ||= self.lesson.steps.count + 1
  end



  def lesson
    Lesson.find(self.lesson_id)
  end

  def previous_step
    Step.where(lesson_id: lesson_id, step_number: step_number-1).first
  end

  def next_step
    Step.where(lesson_id: lesson_id, step_number: step_number+1).first
  end

  #~~~~ param helpers
  def setArrayThroughSymbolWithTitle(symbol, array, title)
    command = "#{symbol.to_s}="
    self.send(command, { title => array })
  end



end
