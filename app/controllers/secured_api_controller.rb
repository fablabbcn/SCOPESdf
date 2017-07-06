class SecuredApiController < ApplicationController
  # TODO _ this needs to be secured and available only to a login user

  def user_presence
    puts api_user_presence_params[:email]
    email = api_user_presence_params[:email]
    puts email
    puts User.first.email
    status = User.exists?(email: email) ? true : false
    render :json => { response: status }
  end

  private
  def api_user_presence_params
    params.permit(:email, :secured_api)
  end
end

