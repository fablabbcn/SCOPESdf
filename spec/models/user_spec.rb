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

describe User, type: :model do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  let(:user) { create(:user) }
  let(:additional_information) {
    {
      skills: %w(CNC Software Design),
      other_interests: %w(my personal interests),
      subjects: %w(mathematics arts),
      involvements: ['informal educator', 'volunteer']
    }
  }
  let(:parsed_skills) {
    [{ name: 'CNC' }, { name: 'Software' }, { name: 'Design' }]
  }
  let(:additional_information_with_blank_strings) {
    {
      involvements: ['volunteer', '', ''],
      other_interests: ['', 'interest']
    }
  }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

  describe '#add_other_information' do
    it 'calls appropiate method with valid argument' do
      expect(user).to receive(:setSubjects).with(additional_information[:subjects]).once
      expect(user).to receive(:setInvolvements).with(additional_information[:involvements]).once
      expect(user).to receive(:setOtherInterests).with(additional_information[:other_interests]).once
      # expect(user).to receive(:setSkillsLevels).with(parsed_skills).once
      user.add_other_information additional_information
    end
    context 'when passing blank strings' do
      it 'removes empty string values and calls appropiate' do
        expect(user).to receive(:setInvolvements).with(['volunteer']).once
        expect(user).to receive(:setOtherInterests).with(['interest']).once
        user.add_other_information additional_information_with_blank_strings
      end
    end
    context 'no errors thrown' do
      it 'returns true' do
        expect(user.add_other_information additional_information).to eq true
      end
    end
    context 'when an error occurs' do
      before do
        allow(user).to receive(:setOtherInterests).and_raise('exception was raised')
      end
      it 'returns false and add error to user instance' do
        expect(user.add_other_information additional_information).to eq false
        expect(user.errors[:additional_information].first).to eq 'setOtherInterests: exception was raised'
      end
    end
  end

end
