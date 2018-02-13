# frozen_string_literal: true
class LessonsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :update, :delete_file, :upload_file]
  #skip_before_action :verify_authenticity_token

  before_action :set_lesson, only: [:show, :activity]
  before_action :set_contexts, only: [:index, :edit]
  before_action :set_subjects, only: [:index, :edit]
  before_action :set_collections, only: [:index, :edit]
  before_action :set_fabrication_tools, only: [:index, :edit]

  def index
    # Using lessons#index for now as the public view of all lesson
    # No authentication heres

    # Fetch the page number, otherwise 1
    @page = params[:page] || 1

    # Fetch lessons
    @lessons = Lesson.includes(:steps).page(@page)

    # TODO: use filters

    # Fetch subjects
    @filter_subjects = [] # TODO: turn subject param into array to check against

    # set difficulties
    @difficulty_helper = MasteryLevel.form_helper

    # Pagination stub, just so i can style the output - DH
    @paginatable_array = Kaminari.paginate_array([*1..280]).page(params[:page]).per(12)

  end

  def show

    @lesson_obj = Lesson.includes(:steps).find(params[:id])

    set_lesson_sections

    # Fetch any specified section and turn it into a sym, otherwise :overview
    @section = params[:section].present? ? params[:section].to_sym : :overview

  end

  def new

    # We only need to create a new empty lesson with an id here
    # before handing it off to edit. An id might have been provided already.
    # TODO: look up a lesson that in the middle of being created, by session id
    lesson = LessonService.find_or_create_and_update(params[:id], nil, current_user)
    lesson.steps << Step.new(summary: "")

    if lesson.present?
      redirect_to edit_lesson_path(lesson)
    else
      raise lesson.errors
    end

  end

  def edit

    puts "edit here"
    puts params.inspect

    @current_user = current_user

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1
    @lesson_obj = Lesson.find(params[:id])

    #pundit --
    authorize @lesson_obj, :update?

    # If the form step is 2, i.e. standards, we redirect to create the first standard
    redirect_to new_lesson_standard_path(lesson_id: @lesson_obj.id, form_step: @form_step) if @form_step == 2

    # If the form step is 4, i.e. steps, we redirect to edit the first step created
    # when the lesson itself was created
    if @form_step == 4
      @steps = @lesson_obj.steps.order(:created_at).to_a
      unless @steps.present?
        @lesson_obj.steps << Step.new(summary: "")
        @lesson_obj.save!
        puts @lesson_obj.steps
        @steps = @lesson_obj.steps.to_a
      end
      @steps_array = @steps.map{|s| s.id}

      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id, form_step: @form_step)
    end

    if params[:lesson].present?
      @lesson_obj = LessonService.find_or_create_and_update(params[:id], lesson_params, @current_user)
    end
    files_hash = {}
    files_hash[:assessment_criteria_files] = params[:assessment_criteria_files] if params[:assessment_criteria_files].present?
    files_hash[:outcome_files] = params[:outcome_files] if params[:outcome_files].present?

    LessonService.add_file_by_type_to_id(@lesson_obj.id, files_hash) # should not be user first
    @lesson_obj.reload

    # elsif params[:id].present? && params[:step].present? # making a step
    #   Step.find_or_create_and_update(nil, params[:id], step_param, User.first).set_files(params)

    #@collections = CollectionTag.all.to_a.map{|x| x.name.titleize}
    @collections = CollectionTag.all
    @difficulty_helper = MasteryLevel.form_helper
    @teaching_range_helper = TeachingRange.inputRange

  end


  def update

    #raise params.to_yaml

    # print params.inspect

    puts params.inspect


    puts "lesson_params hereeeeee"
    puts lesson_params.inspect

    # Update the lesson
    @lesson_obj = LessonService.find_or_create_and_update(params[:id], lesson_params, User.first)

    # Redirect to the next step
    redirect_to edit_lesson_path(id: @lesson_obj.id, form_step: params[:form_step])

  end

  def upload_file
    @lesson = Lesson.find(params[:id])
     puts params.inspect
    #
    # # TODO - AUTHORIZE USER!!!!!
    # puts params[:files].inspect
    #  puts file_params.inspect
    #
    #  puts "BELOW ME BITCH\n\n\n"
    files = params[:files]
    files_hash = {}
    # puts "br"
    # puts files_hash
    files_hash[:assessment_criteria_files] = files if params[:attr] == "assessment_criteria_files"
    files_hash[:outcome_files] = files if params[:attr] == "outcome_files"
    returning = []

    # @lesson.addFiles( files_hash[:outcome_files][0], :outcome_files)

    if files_hash[:assessment_criteria_files].present?
      files_hash[:assessment_criteria_files].map{|k, v|
        @lesson.addFiles(v, :assessment_criteria)
      }
      @lesson.save!

      for i in 0..files_hash.count-1
        @lesson.reload
        x = @lesson.assessment_criteria_files[i]
        puts JqUploaderService.convert_to_jq_upload(x, @lesson.id, "assessment_criteria")
        returning.append(JqUploaderService.convert_to_jq_upload(x, @lesson.id, "assessment_criteria"))
      end
    elsif files_hash[:outcome_files].present?
      puts "handing outcome files here\n\n\n\n\n"
      files_hash[:outcome_files].map{|k, v|
        @lesson.addFiles(v, :outcome)
      }
      @lesson.save!
      for i in 0..files_hash.count-1
        @lesson.reload
        x = @lesson.outcome_files[i]
        puts JqUploaderService.convert_to_jq_upload(x, @lesson.id, "outcome")
        returning.append(JqUploaderService.convert_to_jq_upload(x, @lesson.id, "outcome"))
      end
    end


    respond_to do |format|
      format.html {
        render json: returning,
               content_type: "text/html",
               layout: false
      }
      format.json {
        render json: { files: returning }
      }
    end
  end

  def delete_file
    @lesson_obj = Lesson.find(params[:id])
    puts params.inspect
    file_name = params[:name]
    attribute = params[:attr]
    state = @lesson_obj.removeFileWithName(attribute.to_sym, file_name)
    # Return the attribute as json
    render json: {deleted: state}
  end

  def publish
    # check to make sure current user is owner and make inactive
    # make sure passes validation
    render json: {success: Lesson.find(params[:id]).publish!}, status: 200
  end

  def delete

    lesson = Lesson.find(params[:id])
    lesson.hidden!

    redirect_to lessons_path

  end



  def file_upload_load
    @lesson = Lesson.find(params[:id])
    returning = []
    if file_params[:attr] == "assessment_criteria_files"
        @lesson.assessment_criteria_files.map{|x|
          returning.push(JqUploaderService.convert_to_jq_upload(x, @lesson.id, "assessment_criteria"))
        }
    elsif
      file_params[:attr] == "outcome_files"
        @lesson.outcome_files.map{|x|
          returning.push(JqUploaderService.convert_to_jq_upload(x, @lesson.id, "outcome"))
        }
    end

    respond_to do |format|
      format.html {
        render json: returning.to_json,
               content_type: "text/html",
               layout: false
      }
      format.json {
        render json: { files: returning }, status: :created, location: @Uploaded
      }
    end
  end

  def remove_file_upload
    puts "prepping for delete"
    puts params.inspect
    @lesson = Lesson.find(params[:id])
    status = @lesson.removeFileWithName(remove_file_params[:attr].to_sym, remove_file_params[:name])
    puts "finished for delete"
    render json: {status: status}, location: @Uploaded
  end


  private

    def lesson_params
      params.require(:lesson).permit(:name, :topline, :summary, :tags, :teacher_notes, :assessment_criteria, :state, :collection_tag, :duration, :student_mastery, :educator_mastery, :teaching_range,other_users_emails: [], learning_objectives: [], further_readings: [], outcome_links: [], associated_places_ids: [], standards: [:name, descriptions: []], subjects: [], fabrication_tools: [], key_concepts: [], key_vocabularies: [], key_formulas: [], skills: [:name, :level], contexts: [])
    end

    def step_params
      params.permit(steps: [:id, :name, :summary, :duration, :description, supporting_images: [], materials: [:number, :name], tools: [], supporting_material: [], external_links: []]) #TODO - supporting materials vs materials... add materials
    end

    def step_param
      params.require(:step).permit(:id, :summary, :duration, materials: [:number, :name], tools: [], external_links: [])
    end

    def file_params # both lessons and steps
      params.permit(:attr, assessment_criteria_files: [], outcome_files: [], supporting_materials: [], supporting_files: [], files: [])
    end

    def remove_file_params
      params.permit(:name, :attr)
    end

    def set_lesson
      # The fetching of the lesson should be shared across methods
    end

    def set_collections
      @collections = CollectionTag.all
    end

    def set_contexts
      @contexts = Context.all
    end

    def set_subjects
      @subjects = Subject.all
    end

    def set_fabrication_tools
      @fabrication_tools = ["Hardware", "Electrical", "Design", "CNC Milling", "Software"]
    end

end
