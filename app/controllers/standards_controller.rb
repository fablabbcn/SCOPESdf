class StandardsController < ApplicationController

  before_action :authenticate_user!
  # TODO - PUT PUNDIT

  before_action :set_lesson, only: [:index, :new, :show, :edit, :update, :destroy]
  before_action :set_standards, only: [:new]
  before_action :set_standard, only: [:show, :edit, :update, :destroy]

  def index

    # Specify section as standards for use in sub nav
    @section = :standards

  end

  def new

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1

  end

  def create
    @lesson = Lesson.find(params["lesson_id"])
    s = Standard.where(name:standard_params[:name]).first
    l = LessonsStandard.new(description: standard_params[:description], index: standard_params[:index])
    l.lesson_id = @lesson.id
    l.standard_id = s.id
    l.save!
    redirect_to lesson_create_path(id: @lesson_obj.id, form_step:3)
  end

  def delete
    @lesson = Lesson.find(params["lesson_id"])
    render :json => {deleted: @lesson.lessons_standards.where(index: standard_params[:index]).first.destroy!}
  end

  private

    def standard_params
      params.require(:standards).permit(:name, :description, :index)
    end

    def delete_params
      params.require(:name)
    end

    def set_standard
      @standard_obj = Standard.find_by_id(params[:id])
    end

  def set_standards
    @standards = Standard.all
    #@standards = Standard.name_array 
  end
end
