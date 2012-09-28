class AddExternalDownloadIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :external_download_id, :string
  end
end
