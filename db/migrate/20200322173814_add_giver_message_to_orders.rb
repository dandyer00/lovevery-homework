class AddGiverMessageToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :giver_message, :text
  end
end
