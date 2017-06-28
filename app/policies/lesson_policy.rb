class LessonPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @lesson = model
  end

  def update?
    @current_user.lesson_tags.where(lesson_id: @lesson.id).exists? #user created the lesson
  end


end

