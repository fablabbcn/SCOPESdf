class LessonsController < ApplicationController
  #before_action :authenticate_user! # ADD THIS OBVIOUSLY
  #after_action :verify_authorized # pundit

  skip_before_filter :verify_authenticity_token # REMOVE THIS OBVIOUSLY

  def new
    @collections = CollectionTag.all.to_a.map{|x| x.name.titleize}
    @subjects = Subject.all.to_a.map{|x| x.name.titleize}
    @context = Context.all.to_a.map{|x| x.name.titleize}

    @form_step = params[:form_step].present? ? params[:form_step] : 1

    # the below is strictly used for the weekend of the 13/7/2017 for submit on new page loads
    if params[:id].present?
      @lesson_obj = Lesson.find(params[:id])
    end

    puts "running"
    if params[:id].present? && !params[:step].present?
      @lesson_obj = Lesson.find(params[:id])
      # same as create endpoint
      puts "appending"

      if params[:lesson].present?
        @lesson_obj = LessonService.find_or_create_and_update(params[:id], lesson_params, User.first)
      end
      files_hash = {}
      files_hash.merge!({assessment_criteria_files: params[:assessment_criteria_files]}) if params[:assessment_criteria_files].present?
      files_hash.merge!({outcome_files: params[:outcome_files]}) if params[:outcome_files].present?

      LessonService.add_file_by_type_to_id(@lesson_obj.id, files_hash, User.first)
      @lesson_obj.reload

    elsif params[:id].present? && params[:step].present? # making a step
      puts "makng a step"
      Step.find_or_create_and_update(nil, params[:id], step_param, User.first).set_files(params)
    else
      puts "creating"
      @lesson_obj = LessonService.find_or_create_and_update(nil, {}, User.first)
      @lesson_obj.reload
    end

  end




  def create
    # id = params[:id]
    # user = @current_user


    # authorize IN PUNDIT
    # id = params[:id]
    # if id
    #   Lesson.find(id).hasAuthor?(@current.User)
    # end

    @lesson = LessonService.find_or_create_and_update(nil, lesson_params, User.first)

    urls = params[:assessment_criteria_files].inspect

    files_hash = {}
    files_hash.merge!({assessment_criteria_files: params[:assessment_criteria_files]}) if params[:assessment_criteria_files].present?
    files_hash.merge!({outcome_files: params[:outcome_files]}) if params[:outcome_files].present?


    LessonService.add_file_by_type_to_id(@lesson.id, files_hash, User.first)
    @lesson.reload


    # puts @lesson.inspect
    render :json => {lesson_id: @lesson.id, files: urls, lesson_obj: @lesson.inspect, publishable: @lesson.publishable?, publishable_details: @lesson.publishable_values}, :status => 200
  end


  def publish
    render :json => {success: Lesson.find(params[:id]).publish!}, :status => 200
  end


  def step_create

  end

  # def update
  #   # not different from above ...
  #   render :json => {status: true, lesson: @lesson.id}, :status => 200
  # end

  def add_step
    @lesson = Lesson.first
    id = nil
    id = step_param[:id] if step_param[:id].present? # updates
    @step = Step.find_or_create_and_update(id, params[:id], step_param, User.first).set_files(params)
    render :json => {success: "OKEY", lesson: @step.id}, :status => 200
  end

  def delete_step
    r = Step.delete_and_update_sibilings(params[:step_id], params[:id], User.first)
    render :json => {success: r}, :status => 200

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
    params.require(:step).permit(:id, :summary, :duration, materials: [:number, :name], tools: [])
  end

  def file_params
    #params.permit(:files => [])
  end

end