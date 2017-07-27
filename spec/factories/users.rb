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

FactoryGirl.define do
  factory :user do
    name "Test User"
    email "test@example.com"
    password "please123"

    trait :admin do
      role 'admin'
    end

  end
end
