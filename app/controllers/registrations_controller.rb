class RegistrationsController < Devise::RegistrationsController
  before_action :set_sign_up_cookies, only: :new
  # http://blog.andrewray.me/how-to-set-up-devise-ajax-authentication-with-rails-4-0/
  # clear_respond_to # if you want the removal of static pages... user/sign_in
  # respond_to :json

  # skip_before_filter :verify_authenticity_token
  REGISTRATION_STEPS = %w(key_details description confirmation)

  def new
    @subjects ||= Subject.all.pluck(:name).map{|x| x.titleize}
    @involvements ||= Involvement::STATIC_INVOLVEMENTS.map{|x| x.titleize}
    @skills ||= Skill.all.pluck(:name).map{|x| x.titleize}
    super
  end

  def create
    session[:sign_up_params].deep_merge!(params[:user])

    # return previous_step_procedure if params[:previous_button]
    # return next_step_procedure unless session[:registration_step] == REGISTRATION_STEPS.last
    #
    # super #do |resource|
      # break unless resource.persisted?
      # if resource.add_other_information alternative_signup_params
      #   # clean no longer needed cookies & proceed
      #   session[:sign_up_params] = session[:registration_step] = nil
      # else
      #   resource.destroy!
      # end
    # end
  end

  def update
    super
  end

  private

    def previous_step_procedure
      unless session[:registration_step] == REGISTRATION_STEPS.first
        session[:registration_step] = REGISTRATION_STEPS[current_step_index - 1]
      end
      redirect_to :new
    end

    def next_step_procedure
      session[:registration_step] = REGISTRATION_STEPS[current_step_index + 1]
      redirect_to :new
    end

    def current_step_index
      REGISTRATION_STEPS.index(session[:registration_step])
    end

    def set_sign_up_cookies
      session[:registration_step] ||= REGISTRATION_STEPS[0]
      session[:sign_up_params] ||= {}
    end

    # override devise's :sign_up_params grabbing session data instead
    def sign_up_params
      super.tap do |parameters|
        break unless session[:sign_up_params][:lonlat]
        parameters[:lonlat] = "POINT(#{session[:sign_up_params][:lonlat]})"
      end
    end

    # params that cannot be used on user creation
    def alternative_signup_params
      session[:user].slice(:involments, :subjects, :skills,
        :other_interests).tap do |parameters|
          break unless session[:sign_up_params][:other_interests]
          parameters[:other_interests] = session[:sign_up_params][:other_interests].split(',')
        end
    end

end
