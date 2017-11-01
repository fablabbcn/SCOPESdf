class PlacesController < ApplicationController

  def index

  end

  def show

    # Fetch any specified section and turn it into a sym, otherwise :overview
    @section = params[:section].present? ? params[:section].to_sym : :overview

  end

end
