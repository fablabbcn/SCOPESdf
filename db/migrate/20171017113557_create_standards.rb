class CreateStandards < ActiveRecord::Migration[5.0]
  def change
    create_table  :standards, id: :uuid,  default: "uuid_generate_v4()", force: :cascade do |t|
      t.string    :name, null: false, index: true
      t.string    :autocomplete, null: true
    end

    create_table :lessons_standards, id: false do |t|
      t.uuid        :lesson_id, index: true, null: false
      t.uuid        :standard_id, index: true, null: false
      t.string     :description
      t.integer    :index
    end
    add_foreign_key(:lessons_standards, :lessons, column: :lesson_id, primary_key: :id)
    add_foreign_key(:lessons_standards, :standards, column: :standard_id, primary_key: :id)

  end
end
