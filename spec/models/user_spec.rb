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
#  avatar                 :string           default("")
#  role                   :integer          default("user"), not null
#  bio                    :string           default(""), not null
#  kind                   :integer          default(0), not null
#  phone_number           :string
#  social                 :json
#  settings               :json             not null
#  primary_org            :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

describe User do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

end
