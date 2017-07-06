class SearchController < ApplicationController

  skip_before_filter :verify_authenticity_token # REMOVE THIS OBVIOUSLY


  # format_response:
  # exists
  # ids
  # objects (default)

  def main
    if params[:entity] == "user"
      returnable = userSearch(search_params[:filter])
    end
    render json: {status: returnable}
  end


  private
  def search_params
    params.require(:search).permit(:format_response, :name, filter: [ :email, :name ])
  end


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Object Searches
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  def userSearch(filter)
    if filter == {}
      return false
    end

    # tested:     email, name
    # puts filter

    result = User.where(filter)
    if search_params[:format_response] == "id"
      return result.map{|u| u.id}
    end
    if search_params[:format_response] == "exists"
      return (result.count > 0) ? true : false
    end
    result.to_a # TODO - see if anything should be hidden?
  end



end
