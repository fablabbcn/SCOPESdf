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

    # def l_tags
    #   self.essentials
    #   Subject.new(name:"Technology").save!
    # end
    def admin
      self.essentials
      user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.name = "SCOPES-df Team"
        user.bio = "SCOPES team bio should be here"
        user.user!
      end
      self.place()
      user.addOrg(Organization.first, false)
      user.save!
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
      place = Organization.find_or_create_by!(name: "Fab Foundation") do |x|
        x.name = "Fab Foundation"
        x.desc = "Formed in 2009 to facilitate and support the growth of the international fab lab network as well as the development of regional capacity-building organizations. The Fab Foundation is a US non-profit 501(c) 3 organization that emerged from MIT’s Center for Bits & Atoms Fab Lab Program. Our mission is to provide access to the tools, the knowledge and the financial means to educate, innovate and invent using technology and digital fabrication to allow anyone to make (almost) anything, and thereby creating opportunities to improve lives and livelihoods around the world. Community organizations, educational institutions and non-profit concerns are our primary beneficiaries.
The Foundation’s programs focus on: education (.edu), organizational capacity building and services (.org), and business opportunity (.com)."
        x.address_line1 = "Milk Street"
        x.address_line2 = "50"
        x.locality = "Boston"
        x.post_code = "02109"
        x.country = "USA"
      end
      place.setPoints(-71.057521, 42.356978)
      place.validated!
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
                  ["user2@example.com"], #will call create user <<
              associated_places_ids:
                  [Organization.first.id],

              # Objectives
              learning_objectives:
                  ["Learn how to build something", "Learn how to build this other thing"],

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
                       descriptions: ["some description here", "and another here"]
                   },
                   {
                       name: "other standard",
                       descriptions: ["other standard desc", "yet another for other standard"]
                   }],

              # Tab 3 - Details
              grade_range: {start: 0, end: 12},
              subjects:
                  ["technology", "science"],
              difficulty_level:
                  {student: "1", educator: "2"},
              skills: [
                  {name: "CNC", level: "4"},
                  {name: "Welding", level: "3"}
              ],
              context:
                  ["In Classroom", "Outdoors"],
              collection_tag: "fab certified/tested",
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
              {number: "4", name: "Computers"},
              {number: "35", name: "Beakers"}
          ],
          tools:
              ["3D Printer"],
          external_links:
              ["https://api.jquery.com/category/manipulation/dom-removal/"],
          # supporting_material >> has own endpoint
      }
      Step.find_or_create_and_update(nil, Lesson.first.id, step, User.first)
    end

    def lantern_seeder

      lesson =
          {
              name: "Laser Cut Lantern - Hong Kong",
              topline: "Light up history and art exploration combining modern day lasercut interpretations of traditional Chinese lanterns and recycled materials",
              summary: "Ethnic Chinese celebrate the harvest worldwide during the Mid-Autumn Festival.  It is synonymous with mooncakes (traditional pastry) and lighting paper lanterns. This lesson will introduce students, from all backgrounds, to this tradition. Rather than purchasing mass-produced plastic lanterns, the lesson will introduce students to the traditional roots of handmade lanterns by teaching them how to make a digital fabricated version using lasers (cutters). Students will add their own personal and creative interpretations. At the same time, the lesson will emphasize sustainability values by using recycled materials for the creations. Our methodology can actually be used to design lanterns for other festivals, like Halloween; or other practical uses, like table lamps.",


              learning_objectives:
                  ["Students will learn about the traditions and values of the Chinese Mid-Autumn Festival.", " Students will learn that holidays reflect different backgrounds, legends, and/or traditions. In this lesson, students will demonstrate their ability to compare and contrast different versions of the Legend of Chang E.", "Students will re-imagine and re-appropriate design traditions into their own Mid-Autumn Festival lantern.", "Students will learn the basics of vector drawing (for this lesson, we will use Inkscape software).", "Students will learn the value of sustainability and upcycling by using recycled cardboard materials for their lanterns.", "Students will learn the basics of laser cutting their own lanterns.", "Students will learn the basics of electronics and light their own lanterns with LEDs.", "Students will gain technical skills by hands-on learning.  Experiences will include making and assembling their own lanterns and using a variety of tools (e.g. hot glue gun).", "Students will recognize that legends are a way of explaining our perception of the world in which we live."],

              description: "Here is description",
              assessment_criteria: "Students will be graded upon construction of their lanterns. Criteria may include:
Did students follow directions correctly?
Did students create a design on their lanterns related to the Mid-Autumn Festival?
Did students use Fab techniques properly?
Did students clean up work spaces completely?
Did students work well with classmates?
",

              further_readings:
                  ["https://www.youtube.com/watch?v=P2r9U4wkjcc", "http://mit.org"],

              step = {
                  summary: "Explore and Compare Two Chang E Legends",
                  duration: "3600",
                  description: "Review Mid-Autumn Festival “Hong-Kong Mid-Autumn Festival
http://www.hongkongextras.com/_mid_autumn_festival.html

Review the Legend of Chang E
http://www.moonfestival.org/the-legend-of-chang-e.html

Review the two Versions of Legend of Chang E (Version 2 starts at the 6:10 mark)
https://www.youtube.com/watch?v=_tTiVekamYk

Students will prepare the main box for the lantern. If materials do not match the materials required for the template, students will use a boxmaker utility (e.g. makercase.com) to generate work plans for material.

Essential Question: Do you know any other stories from other cultures about the sun?

Explain that there are several versions of Legend of Chang E,
Play  two different versions of the Legend of Chang E for the class  https://www.youtube.com/watch?v=_tTiVekamYk
Instruct students to take a closer look at main characters in Legend of Chang E by taking characterization notes:

What do the main characters look like?
What do the main characters do?
What do the main character say?
What do others say about them?


4. Have students share and compare their visualizations in small groups, discussing each character's internal and external conflicts.

5. Introduce the concept of “compare and contrast” by explaining how the technique is used to identify similarities and differences.

6. Comparison and Synthesis of Ideas (CSI).

After closely analyzing the two versions of Legend of Chang E, students will compare and contrast ideas from each.  They should be sure to list the specific words each version used. This strategy can also be used to help students recognize the thematic content that is common to both versions. Students should be able to generate both differences and similarities, as well as synthesize the information that each version shares.

7. Expository Writing Prompt:

Have students work with partners to write an expository paragraph that compares or contrasts the two versions and details about Hou Yi and Chang E. Include examples from different types of characterization, appearance, actions, words, and the reactions of others. Make sure students use:
Topic sentence
Supporting details and commentary
Transition words
Present tense verbs
Correct shifts in pronouns

Formative Assessment: Examine students’ paragraphs to determine their levels of understanding.  Check for structure, topic sentences, transitions, supporting details, and general commentary.

TEACHER NOTE: Teachers could use guided writing to support students in the writing process. They could co-construct a “compare” paragraph --- as a whole class or in small groups ---  and then have students write  “contrast” paragraphs independently.

8. Closure:

Students will summarize what they have learned. A group discussion or questions-and-answers written on the board will reinforce knowledge. Students can compare and contrast Mid-Autumn Festival traditions with their own holidays.
",
                  materials: [
                      {number: "1 per student", name: "Notebooks"},
                  ],
                  tools:
                      ["3D Printer"],
                  external_links:
                      ["https://www.youtube.com/watch?v=_tTiVekamYk", "http://www.moonfestival.org/the-legend-of-chang-e.html", "http://www.hongkongextras.com/_mid_autumn_festival.html"],
              }

      step = {
          summary: "Design & Build Your Own Laser Cut Lantern",
          duration: "3600",
          description: "1. Students design and draw the lantern.





2. Vectorizing the drawing.

First, the relevant drawing is now digitized by taking a digital photo of it.  Then upload the photo to a shared drive, where a computer with a vector graphics software like Inkscape and/or Adobe Illustrator can access it. For Inkscape:

Open the JPG of the lantern drawing in Inkscape
Use Trace Bitmap to strengthen the line drawing
Use “simplify” to simplify the line drawing
Save the drawing as a PDF
Upload the PDF to the shared drive

​​​Design Files:

 Lantern outlines.pdf - https://drive.google.com/file/d/0B3tPBZnliO7ba1NkUDA3TWtYVHc/view?usp=drive_web
​​
 Mooncake shaped lanterns.pdf - https://drive.google.com/file/d/0B3tPBZnliO7bOTdfbTBTdzFDMVk/view?usp=drive_web
​​
 Mid Autumn calligraphy and YMCM logo.pdf - https://drive.google.com/file/d/0B3tPBZnliO7bazJibTV4OHQxUVE/view?usp=drive_web
​

5. Laser-cutting the lantern drawing

Test and calibrate the laser cutter (eg, power, speed, align height and material)
Open the PDF with the laser cutter software (for this lesson, Corel)
Set the area size to that of the proposed shaped lanterns
Highlight drawing to the lasercut and align to the center, then cut

6. Assembling and lighting the lantern

The lanterns will be kept together by folds/flaps, where they should be hot glued together.
Students may continue to design the exterior of the cardboard lantern by eg, painting, pen or colored drawings, stickers. Cellophane can also be added on the interior, if which LEDs are used to give different light effects. These can also be laser-cut engravings on the lantern.
Before sealing the entire lantern in, students should affix the coin battery and choice of color of LED in the desired location. Some students will do more than one LED in different colors for different light effects showing their drawings. Students should affix the LEDs using clear tape for short-term use, and glue for longer term use. Switches can be added for further functionality and longer term use.
the hook is where the MDF handle can be used to hoist the lantern in a horizontal position for your night out!
",
          materials: [
              {number: "Approximately 5 per student", name: "LED"},
              {number: "1 per student", name: "Sheet of recycled cardboard for laser cutting"},
              {number: "1 per student", name: "Optional decorative materials (e.g. colored cellophane, buttons, glitter, etc.)"},
              {number: "1 per student", name: "Coin battery"},
          ],
          tools:
              ["Laser Cutter", "Hot Glue Gun", "Digital Camera", "Computers with 2D Vector Graphic Software"],
          external_links:
              ["https://api.jquery.com/category/manipulation/dom-removal/"],
      }

      standards :
          [{
               name: "Common Core Social Studies Unifying Theme: Development, Movement, and Interaction of Cultures",
               descriptions: ["Role of diversity within and among cultures", "Role of cultural beliefs and values (i.e. such as belief systems, religious faith, or political ideals) in affecting institutions, literature, music, and/or art.", "Effect of ongoing cultural diffusion and change on different ideas and beliefs."]
           },
           {
               name: "Common Core Social Studies Unifying Theme: Social Studies Thinking and Process Skills",
               descriptions: ["Comparing and contrasting", "Identifying cause and effect", "Drawing inferences and making conclusions", "Evaluating", "Distinguishing fact vs. opinion."]
           }
      {
          name: "Common Core Social Studies Unifying Theme: Sequencing and Chronology Skills ",
          descriptions: ["Using the vocabulary of time and place", "Placing events in chronological order", "Sequencing events on a timeline", "Creating timelines", "Understanding concepts of time, continuity, and change."]
      }
      {
          name: "National Visual Arts Standards",
          descriptions: ["NVA 1.4: Students use art materials and tools in a safe and responsible manner", "NVA 2.3: Students use visual structures and functions of art to communicate ideas", "NVA 3.2: Students select and use subject matter, symbols, and ideas to communicate meaning", "NVA 4.1: Students know that the visual arts have both a history and specific relationships to various cultures"]
      }
      {
          name: "I Can Statements for Reading Anchor Standard 1",
          descriptions: ["I can read closely to determine what the text says explicitly", "I can support logical inferences from the text when writing or speaking", "I can cite specific textual evidence to support conclusions"]
      }
      {
          name: "I Can Statements for Reading Anchor Standard 6",
          descriptions: ["I can assess how point of view shapes the content and style of a text", "I can assess how purpose shapes the content and style of a text"]
      }
      {
          name: "I Can Statements for Reading Anchor Standard 8",
          descriptions: ["I can delineate and evaluate specific claims", "I can delineate and evaluate the validity of the reasoning of the claim", "I can delineate and evaluate the sufficiency of the evidence for the reasoning"]
      }
      {
          name: "I Can Statements for Reading Anchor Standard 9",
          descriptions: ["I can analyze how two or more texts address similar themes or topics to build knowledge", "I can analyze how two or more texts address similar themes or topics to compare the authors’ approaches"]
      }
      {
          name: "I Can Statements for Reading Anchor Standard 10",
          descriptions: ["I can read and comprehend complex literary texts independently and proficiently", "I can read and comprehend complex informational texts independently and proficiently"]
      }
      {
          name: "I Can Statements for Writing Anchor Standard 3",
          descriptions: ["I can write a narrative paper", "I can develop a narrator and/or characters", "I can develop a plot", "I can use vocabulary and sensory language"]
      }
      {
          name: "I Can Statements for Writing Anchor Standard 4",
          descriptions: ["I can develop grade-level appropriate writing"]
      }
      {
          name: "I Can Statements for Writing Anchor Standard 8",
          descriptions: ["I can find information from print sources", "I can find information from digital sources", "I can decide if a source is credible"]
      }
      {
          name: "I Can Statements for Writing Anchor Standard 9",
          descriptions: ["I can use pieces from literary texts to support my writing", "I can use pieces from informational text to support my writing"]
      }
      {
          name: "I Can Statements for Reading Anchor Standard 10",
          descriptions: ["I can write routinely for many reasons, purposes, and audiences"]
      }
      {
          name: "Digital Fabrication Competencies: I can statements",
          descriptions: ["(FAB.1): The Design Process: I can use the digital fabrication design process and quality assurance principles to analyze and solve design problems. This includes journal writing to document progress and capture ideas during the development phase., purposes, and audiences", "(FAB.2): Sketching and Visualization: I can brainstorm, conceptualize and sketch design projects and components, by hand sketch. This includes paper prototyping", "(FAB.3): Create Models: I can create models to illustrate the design of project and components This include using and/or creating a file during the modeling process.", "(FAB.3): Create Models: I can create models to illustrate the design of project and components This include using and/or creating a file during the modeling process.", "(FAB.4): Interpret and prepare 2D and 3D drawings: I can create and interpret auxiliary views, orthographic projections, isometric drawing, oblique drawings and perspective drawings. I can also use 2D and 3D modeling software to document work and communicate solutions.", "(FAB.5): Computer-Aided Modeling: I can create models to illustrate the design of projects, including apply manufacturing processes (e.g. casting, molding, separating, assembling, finishing, and rapid prototyping).", "(FAB.7): Precision Digital Fabrication Machining: I can apply principles of precision machining to measuring work pieces, drawing interpretations, and inspect workpieces according to specifications.", "(FAB.8): Measurement and Interpretation: I can interpret drawings and documentation and perform measurements.", "(FAB.9): Layout and Planning: I can determine product requirements, dimensions, and tolerances from drawing and specifications.", "(FAB.10): Implement safety procedures. I can demonstrate knowledge of FAB Lab safety rules and guidelines."]
      }],

          grade_range : {start: 5, end: 9},
          subjects :
          ["technology", "science", "engineering", "arts"],
          difficulty_level :
          {student: "1", educator: "2"},
          skills : [
          {name: "CAD Design", level: "1"},
          {name: "Electrical", level: "1"}
      ],
          context :
          ["In Classroom", "In fablab"],
          collection_tag : "fab certified/tested",
          tags :
          ["Lantern"]
      }


    end

  end
end
