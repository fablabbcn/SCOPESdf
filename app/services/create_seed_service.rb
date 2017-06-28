class CreateSeedService
  class << self
    def l_tags
      TeachingRange.seed
      Subject.new(name:"Technology").save!

    end
    def admin
      user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
          user.password = Rails.application.secrets.admin_password
          user.password_confirmation = Rails.application.secrets.admin_password
          user.admin!
        end
    end
    def place
      place = Organization.find_or_create_by!(name: "Fab Kindergarden") do |x|
        x.name = "Fab Kindergarden"
        x.desc = "Fab ninos, sponsored by Gerber and Russia"
        x.address_line1 = "123 Broadway Stree"
        x.address_line2 = "APT 1337"
        x.locality = "New York"
        x.post_code = "10010"
        x.country = "USA"
        x.setPoints(40.748440,-73.985643)
      end
      User.first.addOrgId?(Organization.first.id)
    end

    def lesson
      lesson = Lesson.find_or_create_by!(name: "Robot Arm") do |x|
        x.name = "Robot Arm"
        # x.topline = "Here is topline"
        # x.summary = "Here is summary"
        # x.learning_objectives = {}
        # x.description = "Here is description"
        # x.assessment_criteria = "Here is criteria"
        # x.further_readings = {}
        # x.difficulty_level = 1
        # x.outcome_links = {}
        ## x.original_lesson = nil
      end
    end

    def step
      step = Step.new(name: "Assemble Materials")
        # x.topline = "Here is topline"
        # x.summary = "Here is summary"
        # x.learning_objectives = {}
        # x.description = "Here is description"
        # x.assessment_criteria = "Here is criteria"
        # x.further_readings = {}
        # x.difficulty_level = 1
        # x.outcome_links = {}
        ## x.original_lesson = nil
        #step_number: 1
      Lesson.first.steps << step
    end
  end
end
