class LessonService
  class << self

    # Expected Parameters
    # id = optional
    # params = see LessonsController::lesson_params
    # calling_user = user making this request


    def find_or_create_and_update(id, params, calling_user)
      # puts params << for testing internally

      prepParams(calling_user, params)
      @lesson = find_or_createHidden(id)
      associateAuthors!
      updateData!
      associatePlaces!
      #~
      @lesson
    end
    def prepParams(usr, params)
      @calling_user = usr
      @lesson_params = params[:lesson]
      @other_authors = params[:users]
      @places = params[:places]
    end


    # acceptable types: assessment_criteria
    def add_file_by_type_to_id(id, file, type, calling_user)
      @lesson = Lesson.find(id)
      return false unless @lesson.hasAuthor?(calling_user)

      url = @lesson.addFiles(file, type.to_sym)
      url
    end
    def remove_file_by_type_to_id(id, file, type, calling_user)
      @lesson = Lesson.find(id)
      return false unless @lesson.isAuthor?(calling_user.id)


      true
    end


    private

    def find_or_createHidden(id)
      Lesson.find_or_create_by!(id: id) do |x|
        x.state = 0
      end
    end

    def associateAuthors!
      @lesson.lesson_tags.where(taggable_type: "User").map{|x| x.destroy } # sanitize
      @lesson.addAuthor(@calling_user.id)
      return unless @other_authors.present?
      @other_authors.map{ |x|
      #   #add author or invite user
        u = User.where(email: x).first
        if u.present?
          @lesson.addAuthor(u.id)
        else
          InviteUserService.invite(x) # TODO - see how to handle lesson... NEED TO ASSOCIATE TO LESSON SOMEHOW
        end
      }
      @lesson.save!
      @lesson.reload
    end

    def updateData!
      @lesson.state = 1   # draft state
      @lesson.attributes = @lesson_params
      @lesson.inspect
      @lesson.save!
      @lesson.reload
    end

    def associatePlaces!
      @lesson.lesson_tags.where(taggable_type: "Organization").map{|x| x.destroy } # sanitize
      return unless @places.present?
      @places.map{ |x|
        @lesson.addOrg(x)
      }
      @lesson.save!
      @lesson.reload
    end


  end
end

# Testing
# calling_user = User.first
# id = nil
# params =