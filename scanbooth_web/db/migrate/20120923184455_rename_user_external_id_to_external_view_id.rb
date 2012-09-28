class RenameUserExternalIdToExternalViewId < ActiveRecord::Migration
  def change
    rename_column :users, :external_id, :external_view_id
  end
end
