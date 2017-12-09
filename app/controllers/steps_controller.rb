class StepsController < ApplicationController

  # Steps are children of lessons. This controller handles the CRUD of a step,
  # but must always have a lesson id provided.
  skip_before_action :verify_authenticity_token

  #before_action :authenticate_user!
  before_action :set_lesson, only: [:index, :new, :show, :edit, :update, :destroy]
  before_action :set_step, only: [:show, :edit, :update, :destroy]

  def index

    @steps = Step.all

    # Specify section as steps for use in sub nav
    @section = :steps

  end

  def show

  end

  def new

    # Simmilar to lessons, create a step and then immediately hand off to edit
    @step_obj = Step.create!(
        lesson_id: @lesson_obj.id,
        summary: ""
    )

    redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @step_obj.id) if @step_obj.present?

  end

  def edit

    # If the step isn't found, return to index
    unless @step_obj.present?
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id)
      return
    end

  end

  def create

    @step_obj = Step.new(step_params)

    # TODO: if create param is set, we need to redirect to new

    respond_to do |format|
      if @step_obj.save
        format.html {redirect_to @step_obj, notice: 'Step was successfully created.'}
        format.json {render :show, status: :created, location: @step_obj}
      else
        format.html {render :new}
        format.json {render json: @step_obj.errors, status: :unprocessable_entity}
      end
    end

  end

  def update
    respond_to do |format|
      puts step_params.inspect

      # # TODO - duration fails because no slider...
      filtred_params = step_params
      # filtred_params.delete(:duration)
      # @step_obj.duration = 0

      if @step_obj.update(filtred_params)
        format.html {redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @step_obj.id)}
        #format.html { redirect_to @step_obj, notice: 'Step was successfully updated.' }
        format.json {render :show, status: :ok, location: @step_obj}
      else
        format.html {render :edit}
        format.json {render json: @step_obj.errors, status: :unprocessable_entity}
      end
    end
  end

  def upload_file
    @step_obj = Step.find(params[:step_id])
    puts params.inspect
    # #
    # # # TODO - AUTHORIZE USER!!!!!
    puts params[:files].inspect

    puts "BELOW ME BITCH\n\n\n"
    files = params[:files]
    files_hash = {}
    puts "br"
    puts files_hash
    files_hash.merge!({images: files}) if file_params[:attr] == "images"
    # files_hash.merge!({outcome_files: files}) if params[:attr] == "outcome_files"
    returning = []
    #
    # # @lesson.addFiles( files_hash[:outcome_files][0], :outcome_files)
    #
    if files_hash[:images].present?
      files_hash[:images].map {|k, v|
        @step_obj.addFiles(v, :images)
      }
      @step_obj.save!
      @step_obj.reload
      for i in 0..files_hash.count-1
        x = @step_obj.images[i]
        puts JqUploaderService.convert_to_jq_upload_step(x, params[:lesson_id], @step_obj.id, "images")
        returning.append(JqUploaderService.convert_to_jq_upload_step(x, params[:lesson_id], @step_obj.id, "images"))
      end
    elsif files_hash[:outcome_files].present?
      # puts "handing outcome files here\n\n\n\n\n"
      # files_hash[:outcome_files].map{|k,v|
      #   @lesson.addFiles(v, :outcome)
      # }
      # @lesson.save!
      # for i in 0..files_hash.count-1
      #   @lesson.reload
      #   x = @lesson.outcome_files[i]
      #   puts JqUploaderService.convert_to_jq_upload(x, @lesson.id, "outcome")
      #   returning.append(JqUploaderService.convert_to_jq_upload(x, @lesson.id, "outcome") )
      #end
    end


    respond_to do |format|
      format.html {
        render :json => returning,
               :content_type => 'text/html',
               :layout => false
      }
      format.json {
        render :json => {:files => returning}
      }
    end
  end

  def delete_file
    @step_obj = Step.find(params[:step_id])
    puts params.inspect
    file_name = params[:name]
    attribute = params[:attr]
    state = @step_obj.removeFileWithName(attribute.to_sym, file_name)
    render :json => {deleted: state}
  end


  def destroy

    # If the step isn't found, return to index
    unless @step_obj.present?
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id)
      return
    end

    # Lessons must always have one step, so don't destroy it if it's the last one
    if @lesson_obj.steps.count >= 2

      # Destroy the step
      @step_obj.destroy

      # Redirect to the lessons first step
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id), notice: 'Step was deleted.'

    else

      # Don't destroy the step, return to edit
      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @step_obj.id), notice: 'A lesson needs at least one step'

    end

  end

  private

  def set_step
    @step_obj = Step.find_by_id(params[:id])
  end

  def step_params
    params.fetch(:step).permit(
        :name,
        :duration,
        :description,
        :summary,
        materials: [],
        fabrication_equipment: [],
        software: [],
        external_links: []
    )
  end

  def file_params # both lessons and steps
    params.permit(:attr, :images => [], :files => [])
  end

end
