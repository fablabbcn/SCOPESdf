# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  role                   :integer          default("user"), not null
#  name                   :string           default(""), not null
#  avatar                 :string           default("")
#  address_line1          :string
#  address_line2          :string
#  address_line3          :string
#  address_line4          :string
#  locality               :string
#  region                 :string
#  post_code              :string
#  country                :string
#  lonlat                 :geography({:srid point, 4326
#  bio                    :string           default(""), not null
#  social                 :json
#  settings               :json             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?
  before_create :set_default_notifications, :if => :new_record?


  mount_uploader :avatar, AvatarUploader


  def set_default_role
    self.role ||= :user
  end

  def set_default_notifications # SAVE USER before messing with settings
    self.settings ||= {contact: { notifications: true, emails: true}, projects: {sort: "date_published"}, newsfeed:{ notifications: true, updated: true, likes: true}}
  end



  # TODO - add validations

  # TODO - validates presence of at least one association which is primary!!!

  # TODO - ATTR: add active / inactive

  # TODO - other interests, what do you do, subjects, skills required... talk with GUI


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  has_many :affiliations, dependent: :destroy
  has_many :organizations, through: :affiliations
  # has_many :tags, as: :taggable

  has_many :user_tags, dependent: :destroy


  has_many :skill_tags, as: :taggable

  class << self #accessors
    def name_search(fuzzy)
      User.where("lower(name) like ?", "%#{fuzzy}%")
    end
    def email_search(fuzzy)
      User.where("lower(email) like ?", "%#{fuzzy}%")
    end
  end


  def addOrg_id(org_uuid, primary)
    org = Organization.withId_(org_uuid).or_nil
    return "failed" if (org == nil)

    unless Affiliation.exists?(user_id: self.id, organization_id: org.id)
      af = Affiliation.new(user_id: self.id, organization_id: org.id)
      af.save
    end

    if self.affiliations.count == 1 || primary
      removePrimaryOrg
      x = Affiliation.where(user_id: self.id, organization_id: org.id).first
      x.primary = true
      x.save!
    end

  end
  def addOrg(org, primary)
    addOrg_id(org.id, primary)
  end
  def primaryOrg
    Affiliation.where(user_id: self.id, primary: true).first.organization
  end
  def removePrimaryOrg
    if self.affiliations.count > 0
      self.affiliations.map{ |af| af[:primary] = false; af.save!}
      # false  # cannot remove primary if just one organization
    end
  end
  def removeOrg(org)
    org = Organization.find(org.id)
    return false if self.primaryOrg == org # cannot remove if just one
    Affiliation.where(user_id: self.id, organization_id: org.id).destroy_all
  end


  def setInvolvements(string_array)
    string_array.map{ |n|
      i = Involvement.find_or_create_by(name: n.downcase)
      self.user_tags << UserTag.new(taggable: i)
    }
  end
  def getInvolvements
    self.user_tags.where(taggable_type: "Involvement").map{|x| y = x.taggable; y.name}
  end
  def removeInvolvement(string)
    self.user_tags.where(taggable_type: "Involvement").map{ |x|y = x.taggable; x.destroy if string.downcase == y.name}
  end


  def setSubjects(string_array)
    string_array.map{ |n|
      s = Subject.find_or_create_by(name: n.downcase)
      self.user_tags << UserTag.new(taggable: s)
    }
  end
  def getSubjects
    self.user_tags.where(taggable_type: "Subject").map{|x| y = x.taggable; y.name}
  end
  def removeSubject(string)
    self.user_tags.where(taggable_type: "Subject").map{ |x|y = x.taggable; x.destroy if string.downcase == y.name}
  end


  def setOtherInterests(string_array)
    string_array.map{ |n|
      oi = OtherInterest.find_or_create_by(name: n.downcase)
      self.user_tags << UserTag.new(taggable: oi)
    }
  end
  def getOtherInterests
    self.user_tags.where(taggable_type: "OtherInterest").map{|x| y = x.taggable; y.name}
  end
  def removeOtherInterest(string)
    self.user_tags.where(taggable_type: "OtherInterest").map{ |x|y = x.taggable; x.destroy if string.downcase == y.name}
  end


  def setSkillsLevels(hash_array) # [{:name, :level}]
    hash_array.map{ |h|
      skill = Skill.find_or_create_by(name: h[:name].downcase)
      skill.skill_tags << SkillTag.new(taggable: self, level: h[:level])
    }
  end
  def getSkillsLevels
    SkillTag.where(taggable_type: "User", taggable_id: self.id).map{|x| y = x.skill; {name: y.name, level: x.level}}
  end
  def changeSkillLevel(name, skill_level)
    SkillTag.where(taggable_type: "User", taggable_id: self.id).map{|x|
      if name == x.skill.name
        x.level = skill_level
        x.save!
      end
    }
  end
  def removeSkill(string)
    skill = Skill.where(name: string.downcase).first
    skill.skill_tags.where(taggable_type: "User", taggable_id: self.id).map{ |x|
     x.destroy if string.downcase == x.skill.name
    } if skill.present?
  end



  private







end
