class LessonsController < ApplicationController
  #before_action :authenticate_user! # ADD THIS OBVIOUSLY
  #after_action :verify_authorized # pundit

  skip_before_filter :verify_authenticity_token # REMOVE THIS OBVIOUSLY

  def create
    @lesson =  Lesson.new(lesson_params[:lesson])
    response = @lesson.save
    @lesson.reload


    SeedService.admin # remove me      <<<<<<<    Get from current user
    user_id = User.first.id # faked...
    @lesson.addAuthor(user_id)



    # TODO - see if we differentiate between authors and contributors
    lesson_params[:users].map{ |x|
      #add author or invite user
      if User.exists?(email: x)
        User.where(email: x).map{ |u|
          @lesson.addAuthor(u.id)
        }
      else
        InviteUserService.invite(x) # TODO - see how to handle lesson
      end
    }


    @lesson.destroy unless response # make sure added author, unless fail... update status
    # TODO - add organization

    #SeedService.place # remove me      <<<<<<<    Get from place given
    org = Organization.first # faked...
    orgs = []
    @lesson.getAuthors.map{ |x| puts x; orgs = (orgs << x.organizations.to_a).flatten! }
    # puts "sdf"
    # puts orgs.inspect
    ## make sure given location is in group
    exists = orgs.any? {|x| x.id == org.id }
    response = response && exists




    # lesson_user_params.map{ |x| puts x}

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
    returnable = params.require(:lesson).permit(:name, :topline, :summary, :description, :assessment_criteria, :difficulty_level, :state, :other_users => [], :learning_objectives =>[], :further_readings =>[], :outcome_links =>[])
    other_users = returnable.delete(:other_users)
    {lesson: returnable, users: other_users}
  end
  def lesson_user_params
    params.require(:lesson).permit(:user=>[])
  end
  def step_params
    params.permit(steps: [ :name, :summary, :duration, :supporting_images =>[], :materials   => [], :tools => [], :supporting_material => [],  ]) #TODO - supporting materials vs materials... add materials
  end

end