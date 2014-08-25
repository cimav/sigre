class CreateMonedas < ActiveRecord::Migration
  def change
    create_table :monedas do |t|
      t.string :codigo
      t.string :nombre

      t.timestamps
    end
  end
end
