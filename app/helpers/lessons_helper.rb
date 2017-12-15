module LessonsHelper
	

	def next_lesson_section(current_section = :overview)
		is_next = false
		@lesson_sections.each do |section, path|
			if is_next
				return path 
			end
			if section == current_section
				is_next = true
			end
		end
	end

	def prev_lesson_section(current_section = :overview)
		is_prev = false
		@lesson_sections.reverse_each do |section, path|
			if is_prev
				return path 
			end
			if section == current_section
				is_prev = true
			end
		end
	end


end