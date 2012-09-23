class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :scan_file
      t.string :external_id

      t.timestamps
    end
  end
end
