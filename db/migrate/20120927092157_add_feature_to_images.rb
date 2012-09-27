class AddFeatureToImages < ActiveRecord::Migration
  def change
    change_table :images do |t|
      t.boolean :feature
    end
  end
end
