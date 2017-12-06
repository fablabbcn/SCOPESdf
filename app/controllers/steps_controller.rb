class StepsController < ApplicationController

  # Steps are children of lessons. This controller handles the CRUD of a step,
  # but must always have a lesson id provided.

  before_action :authenticate_user!
  before_action :set_lesson, only: [:index, :new, :show, :edit, :update, :destroy]
  before_action :set_step, only: [:show, :edit, :update, :destroy]

  def index

    @steps = Step.all

    # Specify section as steps for use in sub nav
    @section = :steps

  end

  def show

  end

  def new

    # Simmilar to lessons, create a step and then immediately hand off to edit
    @step_obj = Step.create!(
      lesson_id: @lesson_obj.id,
      summary: ""
    )

    redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @step_obj.id) if @step_obj.present?

  end

  def edit

    puts params

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1

    # If the step isn't found, return to index
    unless @step_obj.present?
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id)
      return
    end

  end

  def create

    @step_obj = Step.new(step_params)

    if @step_obj.save
      redirect_to @step_obj, notice: nil # don't show a message to the user
    else
      render :new
    end

  end

  def update

    puts step_params.inspect

    # Determine whether to just show the just-saved step, or create a new one
    redirection = step_params[:new_after_save] == 'true' ? new_lesson_step_path(lesson_id: @lesson_obj.id) : edit_lesson_step_path(@lesson_obj, @step_obj) 

    if @step_obj.update(step_params)
      redirect_to redirection, notice: 'Your step was successfully updated.'
    else
      render :edit
    end

  end

  def destroy

    # If the step isn't found, return to index
    unless @step_obj.present?
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id)
      return
    end

    # Lessons must always have one step, so don't destroy it if it's the last one
    if @lesson_obj.steps.count >= 2

      # Destroy the step
      @step_obj.destroy

      # Redirect to the lessons first step
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id), notice: 'Your step was deleted.'

    else

      # Don't destroy the step, return to edit
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @step_obj.id), notice: 'A lesson needs at least one step.'

    end

  end

  private

    def set_step
      @step_obj = Step.find_by_id(params[:id])
    end

    def set_lesson
      @lesson_obj = Lesson.find(params[:lesson_id])
    end

    def step_params
      params.fetch(:step).permit(
        :name,
        :duration,
        :description,
        :new_after_save,
        materials: [],
        fabrication_equipment: [],
        software: [],
        external_links: []
      )
    end

end
