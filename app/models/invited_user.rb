# == Schema Information
#
# Table name: invited_users
#
#  id           :uuid             not null, primary key
#  email        :string           not null
#  data         :json
#  name         :string
#  invite_link  :string           not null
#  confirmed_at :datetime
#  created_at   :datetime         not null
#

class InvitedUser < ApplicationRecord
  before_create :setup_data
  before_create :setup_invite_link

  def setup_data
    self.data ||= {}
  end
  def setup_invite_link
    self.invite_link = generate_link
    while InvitedUser.exists?(invite_link: invite_link) do
      self.invite_link = generate_link
    end
  end

  private
  def generate_link
    SecureRandom.urlsafe_base64
  end

end
