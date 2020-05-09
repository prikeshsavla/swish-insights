class AddAllowPwaToUsersAndSwishes < ActiveRecord::Migration[6.0]
  def change
    add_column :swishes, :allow_pwa, :boolean, default: true
    add_column :users, :allow_pwa, :boolean, default: true
  end
end