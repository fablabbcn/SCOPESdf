# == Schema Information
#
# Table name: lessons
#
#  id                        :uuid             not null, primary key
#  name                      :string           default(""), not null
#  topline                   :string           default(""), not null
#  summary                   :string           default(""), not null
#  learning_objectives       :string           is an Array
#  teacher_notes             :string           default(""), not null
#  assessment_criteria       :string           default(""), not null
#  assessment_criteria_files :string           default([]), is an Array
#  further_readings          :string           is an Array
#  standards                 :json
#  outcome_files             :string           default([]), is an Array
#  original_lesson           :uuid
#  state                     :integer          default("draft"), not null
#  published_at              :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  key_concepts              :string           default([]), is an Array
#  key_vocabularies          :string           default([]), is an Array
#  key_formulas              :string           default([]), is an Array
#  fabrication_tools         :string           default([]), is an Array
#  duration                  :string
#

class Lesson < ApplicationRecord
  enum state: [:hidden, :draft, :visible]

  # TODO - validate publishing only when all content is set

  # TODO - api view sections for content loading

  # TODO - top right buttons..
  # TODO - activity feed == history of lesson_tags

  # TODO - assessment criteria - input field and file format... ( assessment_criteria_docs :: JSON )

  before_create do # lessons initial state
    self.state = 0
  end

  before_save do
    self.key_concepts = self.key_concepts.reject{|x| x.empty? || x == " "} if self.key_concepts.present?
    self.key_vocabularies = self.key_vocabularies.reject{|x| x.empty? || x == " "} if self.key_vocabularies.present?
    self.key_formulas = self.key_formulas.reject{|x| x.empty? || x == " "} if self.key_formulas.present?
    self.fabrication_tools = self.fabrication_tools.reject{|x| x.empty? || x == " "} if self.fabrication_tools.present?
  end


  # #   validates :organization_exists
  # def organization_exists # TODO - validate existece of organization from lesson_tags
  #   # not saved yet... so checking against query doesn't work *
  # end


  has_many :steps, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :lesson_tags, dependent: :destroy

  has_many :lessons_standards
  has_many :standards, through: :lessons_standards

  accepts_nested_attributes_for :steps, allow_destroy: true
  accepts_nested_attributes_for :lessons_standards, allow_destroy: true

  # TODO - search for filter on lesson_tags


  def addAuthor(user_uuid)
    u = User.find(user_uuid)
    self.lesson_tags << LessonTag.new(taggable: u)
  end

  def getAuthors_id
    self.lesson_tags.where(taggable_type: "User").map {|x| y = x.taggable; y.id}
  end

  def authors
    self.lesson_tags.where(taggable_type: "User").map {|x| y = x.taggable; y}
  end

  def removeAuthor(user_uuid)
    self.lesson_tags.where(taggable_type: "User", taggable_id: user_uuid).destroy_all
  end

  def hasAuthor?(u_obj)
    self.lesson_tags.where(taggable_type: "User", taggable_id: u_obj.id).map {|x| y = x.taggable; y if u_obj.id == y.id}.compact.count > 0 ? true : false
  end


  def addOrg(organization_uuid)
    x = Organization.find(organization_uuid)
    self.lesson_tags << LessonTag.new(taggable: x)
  end

  def getOrgs_id
    self.lesson_tags.where(taggable_type: "Organization").map {|x| y = x.taggable; y.id}
  end

  def getOrgs
    self.lesson_tags.where(taggable_type: "Organization").map {|x| y = x.taggable; y}
  end

  def removeOrg(organization_uuid)
    self.lesson_tags.where(taggable_type: "Organization", taggable_id: organization_uuid).destroy_all
  end


  def teaching_range(start_range = nil, end_range = nil)
    if start_range.present? & end_range.present?
      self.lesson_tags.where(taggable_type: "TeachingRange").map {|x| x.destroy} #sanitize
      r = TeachingRange.where(range_start:(start_range) , range_end:(end_range)).first
      LessonTag.new(taggable: r)
      self.lesson_tags << LessonTag.new(taggable: r)
    end
    range = self.lesson_tags.where(taggable_type: "TeachingRange").first
    {range_start: range.taggable.range_start, range_end: range.taggable.range_end} if range.present? && range.taggable.present?
  end
  def teaching_range=(hash)
    hash = eval(hash) if hash.is_a?(String) # params are submitted as string.. conversion if necessary
    teaching_range(hash[:start].to_i + 1, hash[:end].to_i + 1)
  end

  def removeTeachingRange
    self.lesson_tags.where(taggable_type: "TeachingRange").destroy_all
  end

  def teaching_range_formatted
    range = {}
    if teaching_range.present?
      range = teaching_range
      range = {range_start: TeachingRange.format(range[:range_start].gsub("start_", "")), range_end: TeachingRange.format(range[:range_end].gsub("end_", ""))}
    end
    range
  end
  def teaching_range_plain_array
    self.teaching_range_formatted.map{|k,v| x = v[0]; TeachingRange.translate(x)-1}
  end


  def setSubjects(string_array)
    string_array.map {|n|
      s = Subject.find_or_create_by(name: n.downcase)
      self.lesson_tags << LessonTag.new(taggable: s)
    }
  end

  def setSubjects_id(id_array)
    id_array.map {|n|
      s = Subject.find(n)
      self.lesson_tags << LessonTag.new(taggable: s)
    }
  end

  def subjects
    self.lesson_tags.where(taggable_type: "Subject").map {|x| y = x.taggable; y.name}
  end
  def subjects=(s)
    s = s.to_a
    list = s.map{|ss| ss.id}
    setSubjects_id(list)
  end


  def subject_ids
    self.lesson_tags.where(taggable_type: "Subject").map {|x| y = x.taggable; y.id}
  end

  def removeSubject(string)
    self.lesson_tags.where(taggable_type: "Subject").map {|x| y = x.taggable; x.destroy if string.downcase == y.name}
  end

  def removeSubjects
    self.lesson_tags.where(taggable_type: "Subject").destroy_all
  end


  def setMasteryLevel(obj_hash)
    student = MasteryLevel.find_or_create_by(metric: 0, level: obj_hash[:student].to_i) if obj_hash[:student].present?
    educator = MasteryLevel.find_or_create_by(metric: 1, level: obj_hash[:educator].to_i) if obj_hash[:educator].present?
    if student.present?
      student_level = self.lesson_tags.where(taggable_type: "MasteryLevel").first
      student_level.destroy if student_level.present?
    end
    if educator.present?
      educator_level = self.lesson_tags.where(taggable_type: "MasteryLevel").first
      educator_level.destroy if educator_level.present?
    end

    self.lesson_tags << LessonTag.new(taggable: student)
    self.lesson_tags << LessonTag.new(taggable: educator)
  end

  def masteryLevels
    self.lesson_tags.where(taggable_type: "MasteryLevel").map {|x| y = x.taggable; {metric: y.metric, level: y.level}}
  end

  def removeMasteryLevels
    self.lesson_tags.where(taggable_type: "MasteryLevel").destroy_all
  end

  def student_mastery(passed_value = nil)
    self.setMasteryLevel({student: passed_value}) if passed_value
    student = {}
    self.masteryLevels.map {|x| student = x if x[:metric] == "students"}
    return student
  end
  def student_mastery=(val)
    student_mastery(val)
  end
  def student_mastery_formatted
    MasteryLevel.form_value(self.student_mastery[:level]) if self.student_mastery[:level].present?
  end

  def educator_mastery(passed_value = nil)
    self.setMasteryLevel({educator: passed_value}) if passed_value
    educator = {}
    self.masteryLevels.map {|x| educator = x if x[:metric] == "educator"}
    return educator
  end
  def educator_mastery=(val)
    educator_mastery(val)
  end
  def educator_mastery_formatted
    MasteryLevel.form_value(self.educator_mastery[:level]) if self.educator_mastery[:level].present?
  end


  def setSkillsLevels(hash_array) # [{name, level}]
    hash_array.map {|h|
      skill = Skill.find_or_create_by(name: h[:name])
      skill.skill_tags << SkillTag.new(taggable: self, level: h[:level])
    }
  end

  def getSkillsLevels
    SkillTag.where(taggable_type: "Lesson", taggable_id: self.id).map {|x| y = x.skill; {name: y.name, level: x.level}}
  end

  def changeSkillLevel(name, skill_level)
    SkillTag.where(taggable_type: "Lesson", taggable_id: self.id).map {|x|
      if name == x.skill.name
        x.level = skill_level
        x.save!
      end
    }
  end

  def removeSkill(string)
    skill = Skill.where(name: string.downcase).first
    skill.skill_tags.where(taggable_type: "Lesson", taggable_id: self.id).map {|x|
      x.destroy if string.downcase == x.skill.name
    } if skill.present?
  end

  def removeSkills
    SkillTag.where(taggable_type: "Lesson", taggable_id: self.id).destroy_all
  end


  def setContext(string_array)
    string_array.map {|n|
      c = Context.find_or_create_by(name: n.downcase)
      self.lesson_tags << LessonTag.new(taggable: c)
    }
  end

  def setContext_id(id_array)
    id_array.map {|n|
      c = Context.find(n)
      self.lesson_tags << LessonTag.new(taggable: c)
    }
  end
  def contexts=(c)
    c = c.to_a
    list = c.map{|cc| cc.id}
    setContext_id(list)
  end

  def contexts
    self.lesson_tags.where(taggable_type: "Context").map {|x| y = x.taggable; y.name}
  end

  def context_ids
    self.lesson_tags.where(taggable_type: "Context").map {|x| y = x.taggable; y.id}
  end

  def removeContext
    self.lesson_tags.where(taggable_type: "Context").destroy_all
  end


  def setOtherInterests(string_array)
    string_array.map {|n|
      oi = OtherInterest.find_or_create_by(name: n.downcase)
      self.lesson_tags << LessonTag.new(taggable: oi)
    }
  end

  def getOtherInterests
    self.lesson_tags.where(taggable_type: "OtherInterest").map {|x| y = x.taggable; y.name}
  end

  def removeOtherInterest
    self.lesson_tags.where(taggable_type: "OtherInterest").destroy_all
  end


  def setCollectionTag(string)
    ct = CollectionTag.where(name: string.downcase).first
    self.lesson_tags << LessonTag.new(taggable: ct)
  end
  def colletion_tag=(val)

  end
  def setCollectionTag_id(id)
    ct = CollectionTag.find(id)
    self.lesson_tags << LessonTag.new(taggable: ct)
  end

  def collection_tag
    self.lesson_tags.where(taggable_type: "CollectionTag").map {|x| y = x.taggable; y}
  end
  def collection_tag=(ct)
    setCollectionTag_id(ct.id)
  end
  def collection_tag_names
    self.lesson_tags.where(taggable_type: "CollectionTag").map {|x| y = x.taggable; y.name}
  end
  def collection_tag_ids
    self.lesson_tags.where(taggable_type: "CollectionTag").map {|x| y = x.taggable; y.id}
  end

  def removeCollectionTags
    self.lesson_tags.where(taggable_type: "CollectionTag").destroy_all
  end

  # Generic Tags
  def setTags(string_array)
    string_array.map {|n|
      gt = GenericTag.find_or_create_by(name: n.downcase)
      self.lesson_tags << LessonTag.new(taggable: gt)
    }
  end

  def tags
    self.lesson_tags.where(taggable_type: "GenericTag").map {|x| y = x.taggable; y.name}
  end
  def tags=(string_array)
    setTags(string_array.split(',').reject{|x| x.empty? || x == " "})
  end
  def removeTags
    self.lesson_tags.where(taggable_type: "GenericTag").destroy_all
  end


  # Likes
  def setLike(user_uuid)
    u = User.find(user_uuid)
    Like.new(user_id: u.id, lesson_id: self.id).save
  end

  def likes
    Like.where(lesson_id: self.id)
  end

  def getLikes_id
    getLikes_obj.map {|x| x.user_id}
  end

  def getLikes_users
    User.where(id: getLikes_id)
  end

  def removeLike(user_uuid)
    u = User.find(user_uuid)
    Like.where(user_id: u.id, lesson_id: self.id).destroy_all
  end


  mount_uploaders :assessment_criteria_files, SupportingFileUploader
  mount_uploaders :outcome_files, ImageFileUploader


  def addFiles(file, sym)
    returnable = ""
    # puts "FILE HERE THO"
    # puts file
    # puts sym
    case sym
      when :assessment_criteria
        puts "assessment saving"
        collection = self.assessment_criteria_files
        collection ||= []
        collection += [file]
        # puts "current collection", collection
        self.assessment_criteria_files = collection
        self.save!
        self.reload
        returnable = self.assessment_criteria_files.map {|x| x.url}
      when :outcome
        # puts "outcome saving"
        collection = self.outcome_files
        collection ||= []
        collection += [file]
        self.outcome_files = collection
        self.save!
        self.reload
        returnable = self.outcome_files.map {|x| x.url}
    end
    returnable
  end

  def removeFiles(sym)
    returnable = false
    case sym
      when :assessment_criteria
        self.remove_assessment_criteria_files!
        self.save!
        returnable = true
      when :outcome
        self.remove_outcome_files!
        self.save!
        returnable = true
    end
    returnable
  end

  def removeFileWithName(sym, name)
    name.gsub!(" ", "_")
    returnable = false
    case sym
      when :assessment_criteria
        index = nil
        self.assessment_criteria_files.each_with_index {|x, i|
          if (x.path.split("/").last.include?(name))
            index = i
          end
        }
        # puts index
        remain_files = self.assessment_criteria_files # copy the array
        return unless index
        deleted_file = remain_files.delete_at(index) # delete the target image
        deleted_file.try(:remove!) # delete image from S3
        if remain_files.empty?
          self.removeFiles(:assessment_criteria)
        else
          self.assessment_criteria_files = remain_files # re-assign back
        end
        self.assessment_criteria_files_will_change!
        self.save!; self.reload
        returnable = true
      when :outcome
        index = nil
        self.outcome_files.each_with_index {|x, i|
          if (x.path.split("/").last.include?(name))
            index = i
          end
        }
        # puts index
        remain_files = self.outcome_files # copy the array
        return unless index
        deleted_file = remain_files.delete_at(index) # delete the target image
        deleted_file.try(:remove!) # delete image from S3
        if remain_files.empty?
          self.removeFiles(:outcome)
        else
          self.outcome_files = remain_files # re-assign back
        end
        self.outcome_files_will_change!
        puts "running outcome"
        self.save!; self.reload
        returnable = true
    end
    returnable
  end

  def files_destroy_all
    removeFiles(:assessment_criteria)
    removeFiles(:outcome)
  end

  def find_carrier_wave_with_original_name(og_name, sym)
    og_name.gsub!(" ", "_")
    self.reload
    case sym
      when :assessment_criteria
        indexes = []
        self.assessment_criteria_files.each_with_index {|x, i|
          if x.path.split("/").last.include?(og_name)
            indexes.append(i)
          end
        }
        indexes
      when :outcome
        indexes = []
        self.outcome_files.each_with_index {|x, i|
          if x.path.split("/").last.include?(og_name)
            indexes.append(i)
          end
        }
        indexes
    end
  end


  # todo - make search ( for visible only )


  # sole viewing data --
  def further_readings_data
    self.further_readings.map {|x|
      begin
        lt = LinkThumbnailer.generate(x)
        image = VideoThumb::get(x)
        image ||= lt.images.first.src.to_s
        {url: x, title: lt.title, description: lt.description, thumnail: image}
      rescue LinkThumbnailer::Exceptions => e
        {url: x}
      end
    }
  end



  def standards_array
    self.standards["standards"] if self.standards.present?
  end

  def append_standards(standard)
    if self.standards_array.select {|h| h["name"] == standard["name"]}.count > 0
      return false
    end
    standards = self.standards_array
    standards.append(standard)
    self.override_standards(standards)
  end

  def delete_standards(name)
    standards = self.standards_array
    standards.reject! {|s| s["name"] == name}
    returnable = (self.standards_array.count == standards.count)
    self.override_standards(standards)
    !returnable
  end

  def sanitize_standards!
    self.standards = {standards: []}
    self.save!
  end

  def override_standards(given)
    self.standards = {standards: given}
    self.save
  end


  def stats
    {likes: self.likes.count, forks: Lesson.where(original_lesson: self.id).count}
  end

  def get_all_materials
    total_steps = []
    steps.map {|s| total_steps.push(s.materials)}
    total_steps.flatten.compact.uniq
  end

  def get_all_tools
    steps.map {|s| s.tools}.flatten.uniq
  end

  def get_all_supporting
    x = steps.map {|s| s.supporting_files}.flatten
    x.append(steps.map {|s| s.supporting_materials}.flatten)
    x.flatten.compact
  end


  def publishable_values
    {
      overview: {
        title: self.name.present?,
        quick_pitch: self.topline.present?,
        summary: self.summary.present?,
        learning_objectives: self.learning_objectives.present?,
        teacher_notes: self.teacher_notes.present?,
        assessment_criteria: self.assessment_criteria.present?
      },
      standards:{
        standards: self.standards.present? # TODO - needs updating with form!
      },
        details: {
          teaching_range: self.teaching_range.present? && self.teaching_range[:range_start].present? && self.teaching_range[:range_end].present?,
          subjects: self.subjects.present?,
          fabrication_tools: self.fabrication_tools.present?,
          concepts: self.key_concepts.present?,
          vocabularies: self.key_vocabularies.present?,
          formulas: self.key_formulas.present?,
          tags: self.tags.present?
        },
        instructions:{ steps: self.steps.present?}, # TODO - needs updating with steps!
        outcomes: { outcomes: true}
    }
  end

  def publishable?(section = nil)
    ready = true
    unless section # if no param
      self.publishable_values.each {|k, v|
        v.each {|k1, v1|
          ready = v1 && ready
        }
      }
    else # if param
      self.publishable_values[section].each{|k,v|
        ready = v && ready
      }
    end
    ready
  end

  def publishable_count
    self.publishable_values.select{|k, v|
      ready = true
      v.each {|k1, v1|
        ready = v1 && ready
      }
      k.to_s unless !ready
    }.count
  end

  def publish!
    if publishable?
      self.published_at = Time.now
      self.visible!
      return true
    end
    return false
  end


  def to_s
    name.present? ? name : "Untitled Lesson"
  end

end
