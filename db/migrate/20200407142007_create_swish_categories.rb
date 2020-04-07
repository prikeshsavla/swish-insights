class CreateSwishCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :swish_categories do |t|
      t.references :swish, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
