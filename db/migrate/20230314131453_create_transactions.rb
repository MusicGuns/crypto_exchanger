class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :send_usdt
      t.decimal :get_btc
      t.text :txid
      t.decimal :rate

      t.timestamps
    end
  end
end
