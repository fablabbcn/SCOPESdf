# frozen_string_literal: true
namespace :lessons do

  task seed: :environment do

	require 'faker'

	# Creates test lessons
	20.times do |i|

		lesson = Lesson.new

		lesson.name = Faker::Book.title
		lesson.topline = Faker::Lorem.paragraph(1)
		lesson.summary = Faker::Lorem.paragraph(3)
		lesson.learning_objectives = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
		lesson.teacher_notes = Faker::Lorem.paragraph(3)
		lesson.assessment_criteria = Faker::Lorem.paragraph(3)
		lesson.remote_assessment_criteria_files_urls = ["https://source.unsplash.com/1080x808/?#{i}", "https://source.unsplash.com/1080x808/?#{i+1}", "https://source.unsplash.com/1080x808/?#{i+2}"]
		lesson.further_readings = [Faker::Internet.url, Faker::Internet.url, Faker::Internet.url]

		lesson.teaching_range = { start: rand(1..3), end: rand(4..6) }

		lesson.contexts = Context.offset(rand(Context.count)).limit(rand(1..2))
		lesson.subjects = Subject.offset(rand(Subject.count)).limit(rand(1..2))
		lesson.student_mastery = rand(0..2)
		lesson.educator_mastery = rand(0..2)
		lesson.fabrication_tools = ["Hardware", "Electrical", "Design", "CNC Milling", "Software"].sample(2)
		lesson.duration = "About #{rand(1..5)} hours"
		lesson.key_concepts = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
		lesson.key_vocabularies = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
		lesson.key_formulas = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
		lesson.collection_tag = CollectionTag.offset(rand(CollectionTag.count)).first
		#lesson.tags = Faker::Lorem.words(rand(1..6))

		lesson.remote_outcome_files_urls = ["https://source.unsplash.com/1080x808/?#{i}", "https://source.unsplash.com/1080x808/?#{i+1}", "https://source.unsplash.com/1080x808/?#{i+2}"]

		# THIS SHOULD BE lesson.authors << User
		# Tried this but just errored "lesson tags is invalid"
		#lesson.addAuthor(User.offset(rand(User.count)).first.id)

		# Generate 2 standards
		2.times do |i_standard|

			lesson_standard = LessonsStandard.new
			lesson_standard.standard = Standard.offset(rand(Standard.count)).first
			lesson_standard.description = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]

			lesson.lessons_standards << lesson_standard

		end

		# Generate 3 steps
		3.times do |i_step|

			step = Step.new
			step.name = Faker::Lorem.sentence(1)
			step.duration = rand(60..120)
			step.description = Faker::Lorem.paragraph(3)
			step.summary = Faker::Lorem.paragraph(3) ## SHOULDN'T BE NEEDED BUT IS A NON-NULL ATTR
			step.remote_images_urls = ["https://source.unsplash.com/1080x808/?#{i_step}", "https://source.unsplash.com/1080x808/?#{i_step+1}", "https://source.unsplash.com/1080x808/?#{i_step+2}"]
			step.remote_design_files_urls = ["https://source.unsplash.com/1080x808/?#{i_step}", "https://source.unsplash.com/1080x808/?#{i_step+1}", "https://source.unsplash.com/1080x808/?#{i_step+2}"]
			step.materials = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
			#step.tools = # ISN'T REQUIRED CAN BE REMOVED
			step.fabrication_equipment = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
			step.software = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
			step.external_links = [Faker::Internet.url, Faker::Internet.url, Faker::Internet.url]

			lesson.steps << step

		end

		lesson.save!

		# TODO: need to be able to publish a lesson; this doesn't seem to work
		lesson.publish! 

	end

  end

end
