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

  private
  def file_params
    params.permit(:avatar)
  end


end
