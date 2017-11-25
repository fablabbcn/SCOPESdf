class RegistrationsController < Devise::RegistrationsController
  # http://blog.andrewray.me/how-to-set-up-devise-ajax-authentication-with-rails-4-0/
  # clear_respond_to # if you want the removal of static pages... user/sign_in
  # respond_to :json

  # skip_before_filter :verify_authenticity_token

  def new
    @subjects = Subject.all.to_a.map{|x| x.name.titleize}
    @involvements = Involvement.all.to_a.map{|x| x.name.titleize}
    @skills = Skill.all.to_a.map{|x| x.name.titleize}
    super
  end

  def create
    # add custom create logic here
    puts "singing up"
    puts params.inspect
    puts sign_up_params.inspect
    super
    # after super we can then assign other data points to this guy
    puts "current user below"
    puts current_user.inspect
  end

  def update
    super
  end

  private
    def sign_up_params
      params.require(:user).permit(:display_name, :email, :password, :password_confirmation, :bio)
    end
    def alternative_signup_params
      params.permit(:randomField)
    end

end
