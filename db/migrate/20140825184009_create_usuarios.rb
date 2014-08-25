class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string     :usuario,    :null => false
      t.string     :email,       :null => false
      t.string     :nombre,  :null => false
      t.string     :apellidos,   :null => false
      t.string     :token
      t.integer    :status,     :null => false, :default => 1
      t.timestamps
    end
    add_index(:usuarios, :usuario)
    add_index(:usuarios, :email)
  end
end
