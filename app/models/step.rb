# == Schema Information
#
# Table name: steps
#
#  id                  :uuid             not null, primary key
#  lesson_id           :uuid             not null
#  summary             :string           not null
#  duration            :integer          default(0), not null
#  description         :string           default(""), not null
#  supporting_files    :json
#  materials           :json
#  tools               :string           is an Array
#  supporting_material :json
#  step_number         :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Step < ApplicationRecord

  validates :lesson_id, presence: true

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


  mount_uploaders :supporting_files, SupportingFileUploader
  mount_uploaders :supporting_materials, SupportingFileUploader
  def set_files(files)
    puts files.inspect
    self.supporting_files = files[:supporting_files] if files[:supporting_files].present?
    self.supporting_materials = files[:supporting_materials] if files[:supporting_materials].present?
    save!
    reload
  end


  # move the following to its own service:
  def self.find_or_create_and_update(step_id, lesson_id, params, calling_user)
    @lesson = Lesson.find(lesson_id)
    return unless @lesson.hasAuthor?(calling_user)

    # filter params if need be

    @step = Step.new(params)
    @lesson.steps << @step
    @step.save!
    @step.reload

    # find or create
    # if creating add new lesson

    @step
  end

  def reorder(order_number)

  end

  def deleteAndUpdateLesson

  end

end
