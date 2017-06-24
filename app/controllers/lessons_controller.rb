class LessonsController < ApplicationController
  #before_action :authenticate_user!
  #after_action :verify_authorized


  skip_before_filter :verify_authenticity_token # REMOVE THIS OBVIOUSLY

  def create
    @lesson =  Lesson.new(lesson_params)
    response = @lesson.save
    render :json => {status: response}, :status => 200
  end


  def add_step

  end

  private
  def lesson_params
    params.require(:lesson).permit(:name, :topline, :summary, :description, :assessment_criteria, :difficulty_level, :learning_objectives =>[], :further_readings =>[], :outcome_links =>[])
  end

end