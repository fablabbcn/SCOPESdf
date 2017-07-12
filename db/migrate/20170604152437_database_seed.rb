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
      t.integer  :sign_in_count, default: 0, null: false
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

      t.integer   :role, default: 0, null: false
      ## SCOPES p1
      t.string    :name, default: "", null: false
      t.string    :avatar, default: ""

      # p2

      t.string    :bio, default: "", null:  false
      t.json      :social
      t.json      :settings, null: false           # settings are not searchable and do not need any indexing :3 also this makes them easier to be editable
      t.timestamps null: false
    end

    create_table :organizations, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, default: "", null: false, index: true, unique: true
      t.string    :desc, default: "", null: false
      t.json      :social

      t.integer   :teaching_range_start, default: 0, null: true
      t.integer   :teaching_range_end, default: 0, null: true

      t.string    :contact_email, null: true, index: true
      t.integer   :state, default: 0, null: false, index: true

      t.string    :address_line1
      t.string    :address_line2
      t.string    :address_line3
      t.string    :address_line4
      t.string    :locality
      t.string    :region
      t.string    :post_code, index: true
      t.string    :country
      t.st_point  :lonlat, geographic: true, null: true, index: true, using: :gist
      t.timestamps null: false
    end

    create_table :affiliations do |t| # association table
      t.uuid        :user_id,         index: true, null: false
      t.uuid        :organization_id, index: true, null: false
      t.boolean     :primary, index: true, default: false, null: false
      t.timestamps null: false
    end
    add_foreign_key(:affiliations, :users, column: :user_id, primary_key: :id)
    add_foreign_key(:affiliations, :organizations, column: :organization_id, primary_key: :id)


    create_table :lessons, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      # TODO - check me
      # page 1
      t.string      :name,        default: "", null: false, index: true
      t.string      :topline,     default: "", null: false
      t.string      :summary,     default: "", null: false
      # user in tags
      # place in tags
      t.string      :learning_objectives, array: true # searchable?
      t.string      :description, default: "", null: false
      t.string      :assessment_criteria, default: "", null: false #maybe on lesson_tags??
      t.json        :assessment_criteria_files
      t.string      :further_readings, array: true
      # page 2 - standards
      t.json        :standards

      # page 3 - instructions
      # has many steps -- see table
      # page 4 - outcomes
      t.json        :outcome_files
      # forking
      t.uuid         :original_lesson, null: true, index: true
      # state-machine
      t.integer      :state, default: 1, null: false, index: true
      t.timestamps   null: false
    end



    create_table    :steps, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.uuid        :lesson_id, null: false, index: true
      t.string      :summary, null: false
      t.integer     :duration, default: 0, null: false
      t.string      :description, default: "", null: false
      t.json        :supporting_files       # files
      t.json        :materials          # are they searchable?
      t.string      :tools, array: true # searchable?
      t.json        :supporting_materials   # files
      t.integer     :step_number, null: false
      t.timestamps  null: false
    end
    add_foreign_key(:steps, :lessons, column: :lesson_id, primary_key: :id)


    create_table    :likes do |t|
      t.uuid        :lesson_id, null: false, index: true
      t.uuid        :user_id, null: false, index: true
      t.timestamps  null: false
    end
    add_foreign_key(:likes, :lessons, column: :lesson_id, primary_key: :id)
    add_foreign_key(:likes, :users, column: :user_id, primary_key: :id)






    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Tag Tables -> Parents
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    create_table :lesson_tags do |t|
      t.uuid        :taggable_id, null: false
      t.string      :taggable_type, null: false
      # potentially add type_enum for variation on models??
      t.uuid        :lesson_id, index: true, null: false
      t.timestamps  null:false
    end
    add_index :lesson_tags, [:taggable_type, :taggable_id]
    add_foreign_key(:lesson_tags, :lessons, column: :lesson_id, primary_key: :id)

    create_table :user_tags do |t|
      t.uuid        :taggable_id, null: false
      t.string      :taggable_type, null: false
      t.uuid        :user_id, index: true, null: false
      t.timestamps  null:false
    end
    add_index :user_tags, [:taggable_type, :taggable_id]
    add_foreign_key(:user_tags, :users, column: :user_id, primary_key: :id)

    create_table :org_tags do |t|
      t.uuid        :taggable_id, null: false
      t.string      :taggable_type, null: false
      t.uuid        :organization_id, index: true, null: false
      t.timestamps  null:false
    end
    add_index :org_tags, [:taggable_type, :taggable_id]
    add_foreign_key(:org_tags, :organizations, column: :organization_id, primary_key: :id)


    create_table  :skills do |t|    # exclusive to skills_tags tag
      t.string    :name, null: false, index: true
    end
    create_table  :skill_tags do |t|
      t.uuid        :taggable_id, null: false
      t.string      :taggable_type, null: false
      t.integer     :skill_id, index: true, null: false
      t.integer     :level, null: false, index: true
    end
    add_index :skill_tags, [:taggable_type, :taggable_id]
    add_foreign_key(:skill_tags, :skills, column: :skill_id, primary_key: :id)

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Tag Tables -> Children
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    create_table  :teaching_ranges, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t| # lessons and creators
      t.integer   :range_start, default: 0, null: false
      t.integer   :range_end, default: 0, null: false
    end

    create_table  :subjects, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, null: false, index: true
    end

    create_table  :involvements, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, null: false, index: true
    end

    create_table  :other_interests, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, null: false, index: true
    end

    create_table  :difficulty_levels, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.integer    :level, default: 0, null: false, index: true
      t.integer     :metric, default: 0, null: false, index: true
    end

    create_table  :contexts, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, null: false, index: true
    end

    create_table  :collection_tags, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, null: false, index: true
    end
  

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



    create_table  :invited_users, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string      :email, null: false, index: true
      t.string      :invite_link, null: false, index: true
      t.datetime    :confirmed_at, null: true
      t.datetime    :created_at, null: false
    end


  end
end