class VisitorsController < ApplicationController

  def form
    @user = User.first

  end

  def file_form_upload
    uploaded = file_params[:avatar]
    puts uploaded
    u = User.first
    u.attributes = file_params
    u.save!

    render :json => {status: "GUCCI"}, :status => 200
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
    params.permit(:avatar)
  end

  def register_params
    params.require(:invited_user).permit(:name, :email, :organization)
  end



end