class AddAvatarUrlToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :avatar_url, :string
  end
end
