class StandardsController < ApplicationController
  before_action :authenticate_user!
  # TODO - PUT PUNDIT

  def create
    @lesson = Lesson.find(params["lesson_id"])
    @lesson.append_standards(standard_params)
    redirect_to lesson_create_path(id: @lesson_obj.id, form_step:3)
  end

  def delete
    @lesson = Lesson.find(params["lesson_id"])
    returnable = @lesson.delete_standards(delete_params)
    # returning JSON because this should happen in AJAX
    render :json => {deleted: returnable}
  end

  private
  def standard_params
    params.require(:standards).permit(:name, description: [])
  end
  def delete_params
    params.require(:name)
  end
end
