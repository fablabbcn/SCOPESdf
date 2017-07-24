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
      associatePlaces!
      updateData!
      #~
      updateStandards!
      updateTeachingRange!
      updateSubjects!
      updateDifficultyLevel!
      updateSkills!
      updateContext!
      updateOtherInterests!
      updateCollectionTag!
      @lesson
    end
    def prepParams(usr, given)
      if given
        other_users = given.delete(:other_users_emails)
        associated_places = given.delete(:associated_places_ids)
        standards = given.delete(:standards)
        teaching_range = given.delete(:grade_range)
        subjects = given.delete(:subjects)
        difficulty_level = given.delete(:difficulty_level)
        skills = given.delete(:skills)
        context = given.delete(:context)
        other_interests = given.delete(:tags)
        collection = given.delete(:collection_tag)
      end


      params = {
          lesson: given,
          users: other_users,
          places: associated_places,
          standards: standards,
          range: teaching_range,
          subjects: subjects,
          difficulty_level: difficulty_level,
          skills: skills
      }

      # puts skills.inspect

      @calling_user = usr
      @lesson_params = params[:lesson]
      @other_authors = params[:users]
      @places = params[:places]
      @standards = params[:standards]
      @teaching_range = params[:range]
      @subjects = params[:subjects]

      @difficulty_level = difficulty_level
      @skills = skills
      @context = context
      @other_interests = other_interests

      @collection = collection
    end


    # acceptable types: assessment_criteria
    #file_params : {assessment_criteria_files: [], ...}
    def add_file_by_type_to_id(id, file_params, calling_user)
      # puts "PARAMS BELOW"
      # puts file_params.inspect
      @lesson = Lesson.find(id)
      return false unless @lesson.hasAuthor?(calling_user)

      #check https://github.com/dwilkie/carrierwave_direct

      url = file_params.each {|k,v|
        file_type = k.to_s
        file_type.gsub!("_files","")
        @lesson.addFiles(v, file_type.to_sym)
      }
      # puts url

      url
    end
    def remove_file_by_name_type_on_id(id, file, type, calling_user)
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
      return unless @lesson_params.present?
      @lesson.state = 1   # draft state

      # cleaning - from form
      @lesson_params[:learning_objectives].delete("")
      @lesson_params[:further_readings].delete("")

      @lesson.attributes = @lesson_params
      # puts @lesson.inspect
      @lesson.save!
      @lesson.reload
    end

    def associatePlaces!
      return unless @places.present?
      @lesson.lesson_tags.where(taggable_type: "Organization").map{|x| x.destroy } # sanitize
      @places.map{ |x|
        @lesson.addOrg(x)
      }
      @lesson.save!
      @lesson.reload
    end

    def updateStandards!
      return unless @standards.present?
      @lesson.standards = {standards: []}; @lesson.save! #sanitize
      @lesson.standards = {standards: @standards}
      @lesson.save!
      @lesson.reload
    end

    def updateTeachingRange!
      return unless @teaching_range.present? && @teaching_range[:start].present? && @teaching_range[:end].present?
      @lesson.removeTeachingRange # sanitize
      @lesson.setTeachingRange(@teaching_range[:start], @teaching_range[:end])
      @lesson.save!
      @lesson.reload
    end

    def updateSubjects!
      return unless @subjects.present?
      @lesson.removeSubjects
      @lesson.setSubjects(@subjects)
      @lesson.save! 
      @lesson.reload
    end

    def updateDifficultyLevel!
      return unless @difficulty_level.present?
      @lesson.removeDifficultyLevels # sanitize
      @lesson.setDifficultyLevel(@difficulty_level)
      @lesson.save!
      @lesson.reload
    end

    def updateSkills!
      return unless @skills.present?
      @lesson.removeSkills # sanitize
      @lesson.setSkillsLevels(@skills)
      @lesson.save!
      @lesson.reload
    end

    def updateContext!
      return unless @context.present?
      @lesson.removeContext # sanitize
      @lesson.setContext(@context)
      @lesson.save!
      @lesson.reload
    end

    def updateOtherInterests!
      return unless @other_interests.present?
      @lesson.removeOtherInterest # sanitize
      @lesson.setOtherInterests(@other_interests)
      @lesson.save!
      @lesson.reload
    end

    def updateCollectionTag!
      return unless @collection.present?
      @lesson.removeCollectionTags # sanitize
      @lesson.setCollectionTag(@collection)
      @lesson.save!
      @lesson.reload
    end

  end
end

# Testing
# calling_user = User.first
# id = nil
# params =