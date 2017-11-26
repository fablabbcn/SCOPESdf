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
    super { |resource| resource.add_other_information alternative_signup_params }
  end

  def update
    super
  end

  private

    def alternative_signup_params
      params.require(:sign_up).permit(:involments, :subjects, :skills)
    end

end
