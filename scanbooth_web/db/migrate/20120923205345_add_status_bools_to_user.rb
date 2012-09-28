class AddStatusBoolsToUser < ActiveRecord::Migration
  def change
    add_column :users, :printed, :boolean, :default => false
    add_column :users, :mailed, :boolean, :default => false
  end
end
