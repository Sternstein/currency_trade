class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.bigint :currency_id
      t.decimal :amount

      t.timestamps
    end
  end
end
