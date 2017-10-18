class ActivitiesController < ApplicationController

  before_action :authenticate_user!
  # TODO - PUT PUNDIT

  before_action :set_lesson, only: [:index, :new, :show, :edit, :update, :destroy]

  def index

    # Specify section as activity for use in sub nav
    @section = :activity

  end

  private

end
