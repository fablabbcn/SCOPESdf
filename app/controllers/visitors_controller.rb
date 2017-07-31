class VisitorsController < ApplicationController

  def index
    # @lesson = Lesson.limit(4)
    # @lessons = [Lesson.first, Lesson.first, Lesson.first, Lesson.first]
  end

  def form
    @user = User.first
  end

  def policy
    @step = params[:step] || 0
  end

  def file_form_upload
    # uploaded = file_params[:avatar]
    # puts uploaded
    # u = User.first
    # u.attributes = file_params
    # u.save!


    x = params[:outcome_files]
    puts params.inspect
    l = Lesson.first

    l.addFiles(x, :outcome)
    l.save!

    puts "url"
    puts l.outcome_files.first.url



    render :json => {status: l.outcome_files.inspect}, :status => 200
  end

  def about

  end

  def enter
    @step = params[:step] || 0
  end
  def register_interest
    puts register_params.inspect
    org = register_params.delete(:organization)

    InvitedUser.new(name: register_params[:name], email: register_params[:email], data: {org_name: org}).save!
    render :json => {status: "GUCCI"}, :status => 200
  end



  private
  def file_params
    params.permit(:avatar, outcome_files: [])
  end

  def register_params
    params.require(:invited_user).permit(:name, :email, :organization)
  end



end