class LessonsPublicController < ApplicationController
  #~~~~~~~~~~~
  # Public, no need dto check if authorized
  #~~~~~~~~~~~

  def show
    @lesson = Lesson.find(params[:id])
    @step = params[:step]
    @step ||= 1
  end

  def list
    @page = params[:page] || 1
    @lessons = Lesson.page(@page).per(24)
  end


end