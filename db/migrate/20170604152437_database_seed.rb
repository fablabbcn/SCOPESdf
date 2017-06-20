class DatabaseSeed < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp' # enabled for UUID

    create_table  :users, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|

      ## Database authenticatable
      t.string :email,              null: false, default: "", index: true, unique: true
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token, index: true, unique: true
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet   :current_sign_in_ip
      t.inet   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## SCOPES
      t.string    :name, default: "", null: false
      t.integer   :role, default: 0, null: false
      t.string    :avatar_url
      t.string    :bio, default: "", null:  false
      t.integer   :kind, default: 0, null:  false
      t.string    :phone_number
      t.json      :social
      t.json      :settings, null: false           # settings are not searchable and do not need any indexing :3 also this makes them easier to be editable
      t.timestamps null: false
    end


    create_table :organizations, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, default: "", index: true, null: false
      t.string    :desc, default: "", null: false
      t.json      :social

      t.integer   :teaching_range_start, default: 0, null: false
      t.integer   :teaching_range_end, default: 0, null: false

      t.string    :address_line1
      t.string    :address_line2
      t.string    :address_line3
      t.string    :address_line4
      t.string    :locality
      t.string    :region
      t.string    :post_code, index: true
      t.string    :country
      t.st_point  :lonlat, geographic: true, null: false, index: true, using: :gist
      t.timestamps null: false
    end


    create_table :affiliations do |t|
      t.uuid        :user_id,         index: true, null: false
      t.uuid        :organization_id, index: true, null: false
      t.timestamps null: false
    end
    add_foreign_key(:affiliations, :users, column: :user_id, primary_key: :id)
    add_foreign_key(:affiliations, :organizations, column: :organization_id, primary_key: :id)



    create_table :lesson_tags do |t|
      t.uuid        :taggable_id, null: false
      t.integer     :taggable_type, null: false
      t.uuid        :lesson_id, index: true, null: false
      t.timestamps  null:false
    end
    add_index :lesson_tags, [:taggable_type, :taggable_id]


    create_table :lessons, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      # TODO - finish me
      t.timestamps null: false
    end


  end
end