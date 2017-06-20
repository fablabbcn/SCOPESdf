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
#  name                   :string           default(""), not null
#  role                   :integer          default("user"), not null
#  avatar_url             :string
#  bio                    :string           default(""), not null
#  kind                   :integer          default(0), not null
#  phone_number           :string
#  social                 :json
#  settings               :json             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?
  before_create :set_default_notifications, :if => :new_record?


  def set_default_role
    self.role ||= :user
  end

  def set_default_notifications
    self.settings ||= {contact: { notifications: true, emails: true}, projects: {sort: "date_published"}, newsfeed:{ notifications: true, updated: true, likes: true}}
  end



  # TODO - add validations
  # TODO - ATTR: add active / inactive

  # TODO - https://github.com/carrierwaveuploader/carrierwave ?? for files?? or just FOG?

  # TODO - other interests, what do you do, subjects, skills required... talk with GUI


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  has_many :affiliations
  has_many :organizations, through: :affiliations
  has_many :tags, as: :taggable

  def addOrg?(org_uuid)
    org = Organization.withId_(org_uuid).or_nil
    return "failed" if (org == nil)
    self.organizations << org
    true
  end





end
