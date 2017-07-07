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

  has_many :user_tags, as: :taggable

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

  private







end
