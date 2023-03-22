class AddEmailToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :email, :text
  end
end
