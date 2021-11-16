class CreateCurrencies < ActiveRecord::Migration[6.1]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :description
      t.string :flag

      t.timestamps
    end
  end
end
