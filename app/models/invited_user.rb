# == Schema Information
#
# Table name: invited_users
#
#  id           :uuid             not null, primary key
#  email        :string           not null
#  invite_link  :string           not null
#  confirmed_at :datetime
#  created_at   :datetime         not null
#

class InvitedUser < ApplicationRecord

end
