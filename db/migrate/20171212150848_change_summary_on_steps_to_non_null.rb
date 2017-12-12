class ChangeSummaryOnStepsToNonNull < ActiveRecord::Migration[5.0]
  def change
    change_column :steps, :summary, :string, null: true

  end
end
