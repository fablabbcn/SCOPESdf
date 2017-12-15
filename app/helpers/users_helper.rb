module UsersHelper
	
	def next_person_section(current_section = :overview)
		is_next = false
		@person_sections.each do |section, path|
			if is_next
				return path 
			end
			if section == current_section
				is_next = true
			end
		end
	end

	def prev_person_section(current_section = :overview)
		is_prev = false
		@person_sections.reverse_each do |section, path|
			if is_prev
				return path 
			end
			if section == current_section
				is_prev = true
			end
		end
	end

end