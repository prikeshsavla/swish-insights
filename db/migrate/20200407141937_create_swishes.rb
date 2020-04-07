class CreateSwishes < ActiveRecord::Migration[6.0]
  def change
    create_table :swishes do |t|
      t.string :url
      t.jsonb :data
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
