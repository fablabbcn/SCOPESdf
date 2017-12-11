# frozen_string_literal: true
class StandardsController < ApplicationController

  before_action :authenticate_user!
  # TODO - PUT PUNDIT

  before_action :set_lesson, only: [:index, :new, :show, :create, :edit, :update, :destroy]
  before_action :set_standards, only: [:new, :edit]
  before_action :set_lessons_standard, only: [:show, :edit, :update, :destroy]

  def index

    # Specify section as standards for use in sub nav
    @section = :standards

  end

  def new

    @lessons_standard_obj = LessonsStandard.new(lesson: @lesson_obj)

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1

  end

  def edit

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1

  end

  def create

    @lessons_standard_obj = LessonsStandard.new(lessons_standards_params)
    @lessons_standard_obj.lesson = @lesson_obj

    if @lessons_standard_obj.save
      redirect_to redirection, notice: "Your standard was successfully created."
    else
      render :new
    end

  end

  def update

    if @lessons_standard_obj.update(lessons_standards_params)
      redirect_to redirection, notice: 'Your standard information was successfully updated.'
    else
      render :edit
    end

  end

  def destroy
    
    # If the standard isn't found, return to index
    unless @lessons_standard_obj.present?
      redirect_to lesson_standards_path(lesson_id: @lesson_obj.id)
      return
    end

    # Destroy the step
    @lessons_standard_obj.destroy

    # Redirect to the lessons first step
    redirect_to new_lesson_standard_path(lesson_id: @lesson_obj.id), notice: 'Your standard was deleted.'

  end

  private

    def lessons_standards_params
      params.fetch(:lessons_standards).permit(:standard_id, :new_after_save, description: [])
    end

    def set_lessons_standard
      @lessons_standard_obj = LessonsStandard.includes(:standard).find_by(id: params[:id])
    end

    def redirection
      # Determine whether to just show the just-saved step, or create a new one
      redirection = lessons_standards_params[:new_after_save] == 'true' ? new_lesson_standard_path(lesson_id: @lesson_obj.id) : edit_lesson_standard_path(@lesson_obj, @lessons_standard_obj) 
    end

    def set_standards
      # Exclude any standards that have already been associated with this lesson
      @standards = @lesson_obj.standards.exists? ? Standard.where("id NOT IN (?)", @lesson_obj.standards.ids).all : Standard.all
    end

end
