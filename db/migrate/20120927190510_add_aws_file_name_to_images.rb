class AddAwsFileNameToImages < ActiveRecord::Migration
  def change
    change_table :images do |t|
      t.string :aws_file_name
    end
  end
end
