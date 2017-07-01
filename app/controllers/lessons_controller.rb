class LessonsController < ApplicationController
  #before_action :authenticate_user! # ADD THIS OBVIOUSLY
  #after_action :verify_authorized # pundit

  skip_before_filter :verify_authenticity_token # REMOVE THIS OBVIOUSLY

  def create
    @lesson =  Lesson.new(lesson_params)
    response = @lesson.save
    @lesson.reload
    # uncomment below for functionality
    # response = response && @lesson..lesson_tags << LessonTag.new(taggable: @current_user) # adding author
    # copy and do the same for organization after validation

    @lesson.destroy unless response # make sure added author, unless fail... update status
    # TODO - add organization
    render :json => {status: response, lesson: @lesson.id}, :status => 200
  end
  def update
    @lesson = Lesson.find(params[:id])
    # authorize @lesson -- check to see if user authored
    @lesson.attributes = lesson_params
    @lesson.save!
    render :json => {status: response, lesson: @lesson.id}, :status => 200
  end

  def add_step
    @lesson = Lesson.first
    # @lesson = Lesson.find(params[:id])
    # authorize @lesson, update? -- check to see if user authored
    step_params[:steps].map{ |x|
       puts x
      s = Step.new(x)
      s.setArrayThroughSymbolWithTitle(:supporting_images, x[:supporting_images], "images")
      s.setArrayThroughSymbolWithTitle(:supporting_material, x[:supporting_material], "materials")


       puts s.inspect
      #@lesson.steps << s
    }
    render :json => {status: "OKEY", lesson: @lesson.id}, :status => 200
  end

  def publish

  end
  def draft

  end

  private
  def lesson_params
    params.require(:lesson).permit(:name, :topline, :summary, :description, :assessment_criteria, :difficulty_level, :state, :learning_objectives =>[], :further_readings =>[], :outcome_links =>[])
  end
  def step_params
    params.permit(steps: [ :name, :summary, :duration, :supporting_images =>[], :materials   => [], :tools => [], :supporting_material => [],  ]) #TODO - supporting materials vs materials... add materials
  end

end