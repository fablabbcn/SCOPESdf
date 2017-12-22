class PeopleController < ApplicationController

  def index

    # Pagination stub, just so i can style the output - DH
    @paginatable_array = Kaminari.paginate_array([*1..280]).page(params[:page]).per(12)

  end

  def show

    # Person obj
    @person_obj = User.first

    set_person_sections

    # Fetch any specified section and turn it into a sym, otherwise :overview
    @section = params[:section].present? ? params[:section].to_sym : :overview

  end


end
