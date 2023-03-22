class AddAddressToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :address, :text
  end
end
