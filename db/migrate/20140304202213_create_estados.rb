class CreateEstados < ActiveRecord::Migration
  def change
    create_table :estados do |t|
      t.string :nombre
      t.string :codigo
      t.string :lat,  :limit => 20
      t.string :long, :limit => 20
      t.timestamps
    end
  end
end
