class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.float :course
      t.date :month
      t.references :currency

      t.timestamps
    end
    add_index :rates, :currency_id
  end
end
