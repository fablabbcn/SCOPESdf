class LessonPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @lesson = model
  end

  def update?
    @lesson.hasAuthor?(@current_user) #user is author, and can therefore upadate
  end

end

