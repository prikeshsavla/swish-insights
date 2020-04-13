class CreateSwishReport < ActiveRecord::Migration[6.0]
  def change
    create_table :swish_reports do |t|
      t.float :performance
      t.float :accessibility
      t.float :best_practices
      t.float :pwa
      t.float :seo
      t.float :first_contentful_paint
      t.float :speed_index
      t.float :time_to_interactive
      t.float :first_meaningful_paint
      t.float :first_cpu_idle
      t.float :estimated_input_latency
      t.binary :data
      t.references :swish, null: false, foreign_key: true

      t.timestamps
    end
  end
end
