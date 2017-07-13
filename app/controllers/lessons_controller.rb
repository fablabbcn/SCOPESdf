class LessonsController < ApplicationController
  #before_action :authenticate_user! # ADD THIS OBVIOUSLY
  #after_action :verify_authorized # pundit

  skip_before_filter :verify_authenticity_token # REMOVE THIS OBVIOUSLY

  def create
    # id = params[:id]
    # user = @current_user

    @lesson = LessonService.find_or_create_and_update(nil, lesson_params, User.first)

    # puts params[:assessment_criteria_files].inspect

    urls = params[:assessment_criteria_files].inspect

    files_hash = {}
    files_hash.merge!({assessment_criteria_files: params[:assessment_criteria_files]}) if params[:assessment_criteria_files].present?
    files_hash.merge!({outcome_files: params[:outcome_files]}) if params[:outcome_files].present?


    LessonService.add_file_by_type_to_id(@lesson.id, files_hash, User.first)
    @lesson.reload



    # puts @lesson.inspect
    render :json => {lesson: @lesson.id, files: urls, lesson_obj: @lesson.inspect}, :status => 200
  end

  def update
    # not different from above ...
    render :json => {status: true, lesson: @lesson.id}, :status => 200
  end

  def add_step
    @lesson = Lesson.first
    # @lesson = Lesson.find(params[:id])
    # authorize @lesson, update? -- check to see if user authored
    step_params[:steps].map {|x|
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

  def fileUpload #breaking this
    # puts params[:id]
    # puts file_params.inspect
    # puts file_params[:files]
    puts "D"
    x = file_params[:files]
    puts x.count

    id = Lesson.first.id
    #r = LessonService.add_file_by_type_to_id(id, file_params[:files], params[:atr], User.second)  # this is broken due to refactor
    render :json => {response: r}, :status => 200

  end

  private
  def lesson_params
    params.require(:lesson).permit(:name, :topline, :summary, :description, :assessment_criteria, :state, :collection_tag, other_users_emails: [], learning_objectives: [], further_readings: [], outcome_links: [], associated_places_ids: [], standards: [:name, descriptions: []], grade_range: [:start, :end], subjects: [], difficulty_level: [:student, :educator], skills: [:name, :level], context: [], tags: [])
  end

  def step_params
    params.permit(steps: [:name, :summary, :duration, :supporting_images => [], :materials => [], :tools => [], :supporting_material => []]) #TODO - supporting materials vs materials... add materials
  end

  def step_param
    params.require(:step).permit(:summary, :duration, materials: [:number, :name], tools: [])
  end

  def file_params
    #params.permit(:files => [])
  end

end