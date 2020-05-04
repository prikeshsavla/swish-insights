class AddSequentialIdToSwishes < ActiveRecord::Migration[6.0]
  def change
    add_column :swishes, :sequential_id, :integer
  end
end
