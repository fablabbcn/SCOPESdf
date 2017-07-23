class LessonsPublicController < ApplicationController
  # PUBLIC NO CHECKING OF AUTHORIZED

  def show
    @lesson = Lesson.find(params[:id])
    @step = params[:step]
    @step ||= 1
  end

end