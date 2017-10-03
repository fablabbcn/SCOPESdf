class SearchController < ApplicationController

  skip_before_filter :verify_authenticity_token # REMOVE THIS OBVIOUSLY


  ## Search
  # "GET" "http://localhost:3000/search/:entity"
  # filter is the attribute you want to search on.. currently set up for email and name on user
  # format_response is how you want to get the data back: `id` is list of ids, `exists` is boolean of presence



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
    puts filter.inspect



    # tested:     email, name
    # puts filter

    result = User.where(filter)

    if filter.key?("email")
      result = User.email_search(filter["email"])
    else filter.key?("name")
      result = User.name_search(filter["name"])
    end




    if search_params[:format_response] == "id"
      return result.map{|u| u.id}
    end
    if search_params[:format_response] == "exists"
      return (result.count > 0) ? true : false
    end
    result.to_a # TODO - see if anything should be hidden?
  end



end
