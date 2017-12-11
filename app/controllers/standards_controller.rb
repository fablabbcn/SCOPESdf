# frozen_string_literal: true
class StandardsController < ApplicationController

  before_action :authenticate_user!
  # TODO - PUT PUNDIT

  before_action :set_lesson, only: [:index, :new, :show, :edit, :update, :destroy]
  before_action :set_standards, only: [:new, :edit]
  before_action :set_lessons_standard, only: [:show, :edit, :update, :destroy]

  def index

    # Specify section as standards for use in sub nav
    @section = :standards

  end

  def new

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1

  end

  def edit

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1

  end

  def create
    @lesson = Lesson.find(params["lesson_id"])
    s = Standard.where(name: standard_params[:name]).first
    l = LessonsStandard.new(description: standard_params[:description], index: standard_params[:index])
    l.lesson_id = @lesson.id
    l.standard_id = s.id
    l.save!
    redirect_to edit_lesson_path(id: @lesson.id, form_step: 3)
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

    def standard_params
      params.require(:standards).permit(:name, :description, :index)
    end

    def delete_params
      params.require(:name)
    end

    def set_lessons_standard
      @lessons_standard_obj = LessonsStandard.includes(:standard).find_by(id: params[:id])
    end

    def set_standards
      @standards = Standard.all
      #@standards = Standard.name_array
    end

end
