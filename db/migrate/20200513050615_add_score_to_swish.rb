class AddScoreToSwish < ActiveRecord::Migration[6.0]
  def change
    add_column :swishes, :score, :float
  end
end
