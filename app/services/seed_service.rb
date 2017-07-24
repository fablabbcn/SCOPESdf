class SeedService
  class << self
    def essentials
      TeachingRange.seed
      DifficultyLevel.seed
      Subject.seed
      Involvement.seed
      Skill.seed
      Context.seed
      CollectionTag.seed
    end

    def l_tags
      self.essentials
      Subject.new(name:"Technology").save!
    end
    def admin
      self.essentials
      user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
          user.password = Rails.application.secrets.admin_password
          user.password_confirmation = Rails.application.secrets.admin_password
          user.user!
      end
      self.place()
      ##user.addOrg(Organization.first, false)
      user
    end
    def user
      user = User.find_or_create_by!(email: "otherUser@gmail.com") do |user|
        user.name = "Lucas Lorenzo Pena"
        user.password = "somepassword"
        user.password_confirmation = "somepassword"
        user.user!
      end
      user.setInvolvements(["classroom teacher"])
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
      User.first.addOrg(Organization.first, true)
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

    def lesson_service
      lesson =
            {
                # TAB 1 - Overviewr
                # Basic Information
                name: "Name here",
                topline: "Here is topline",
                summary: "Here is summary",

                # Authors
                other_users_emails:
                    ["user2@example.com" ], #will call create user <<
                associated_places_ids:
                    [ Organization.first.id ],

                # Objectives
                learning_objectives:
                    [ "Learn how to build something", "Learn how to build this other thing"],

                # Lesson Ambitions
                description: "Here is description",
                assessment_criteria: "Here is criteria",
                # assessment_criteria_files get set on another form!!

                further_readings:
                    ["https://www.youtube.com/watch?v=P2r9U4wkjcc", "http://mit.org"],


                # TAB 2 - Standards

                standards:
                    [{
                        name: "standard name is here",
                        descriptions: [ "some description here", "and another here" ]
                    },
                    {
                        name: "other standard",
                        descriptions: [ "other standard desc", "yet another for other standard" ]
                    }],

                # Tab 3 - Details
                grade_range: {start: 0, end: 12},
                subjects:
                    ["technology", "science"],
                difficulty_level:
                    { student: "1", educator: "2" },
                skills: [
                    { name: "CNC", level: "4" },
                    { name: "Welding", level: "3" }
                ],
                context:
                    ["In Classroom", "Outdoors"],
                collection_tag: "Gold Standard Lesson",
                tags:
                    ["Pinball"]
            }

      LessonService.find_or_create_and_update(nil, lesson, User.first)

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

    def step_service
      step = {
          summary: "Step Subject Here",
          duration: "1508",
          description: "description of my step here",
          # supporting_files  >> has its own endpoint
          materials: [
              {number: "4",   name: "Computers" },
              {number: "35",  name: "Beakers" }
          ],
          tools:
              ["3D Printer"],
          external_links:
              ["https://api.jquery.com/category/manipulation/dom-removal/"],
          # supporting_material >> has own endpoint
      }
      Step.find_or_create_and_update(nil, Lesson.first.id, step, User.first)
    end
  end
end
