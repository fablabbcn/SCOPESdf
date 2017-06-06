class CreateSeedService
  def admin
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.admin!
      end
  end
  def place
    place = Organization.find_or_create_by!(name: "Fab Kindergarden") do |x|
      x.name = "Fab Kindergarden"
      x.desc = "Fab ninos, sponsored by Gerber and Russia"

      x.address_line1 = "123 Broadway Stree"
      x.address_line2 = "APT 1337"
      x.locality = "New York"
      x.post_code = "10010"
      x.country = "USA"
      x.setPoints(40.748440,-73.985643)
    end
  end
end
