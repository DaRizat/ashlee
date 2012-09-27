class AddPermissionssToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :permissions
    end
  end
end
