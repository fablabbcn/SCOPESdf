# frozen_string_literal: true
require "turbolinks/redirection"

class ApplicationController < ActionController::Base

  # Include turbolinks redirection methods
  include Turbolinks::Redirection

  protect_from_forgery prepend: true, with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit :email, :password, :password_confirmation, :name,
                            :avatar, :avatar_cache, :address_line1, :locality, :post_code,
                           :country, :bio, :lonlat, social: []
      end
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

    def set_lesson
      @lesson_obj = Lesson.find_by_id(params[:lesson_id])
    end

    def set_lesson_sections
      @lesson_sections = {
        overview: lesson_path(@lesson_obj.id, section: :overview),
        standards: lesson_standards_path(@lesson_obj.id, section: :standards),
        steps: lesson_steps_path(@lesson_obj.id, section: :steps),
        outcomes: lesson_path(@lesson_obj.id, section: :outcomes),
      }
    end

    def set_person_sections
      @person_sections = {
        overview: person_path(@person_obj.id, section: :overview),
        lessons: person_path(@person_obj.id, section: :lessons)
      }
    end
    

  private

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to (request.referrer || root_path)
  end

end
