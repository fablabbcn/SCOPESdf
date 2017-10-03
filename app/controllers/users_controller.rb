class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized


  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy # Should users be allowed rto be deleted??
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end




  # Content ****************

  def affiliate_organization_id
    authorize User              # todo - needs testing
    response = @user.addOrgId?(params[:organization_id])
    render :json => {status: response}, :status => 200
  end





  private

  def secure_params
    params.require(:user).permit(:role) #add other variables
  end

end
