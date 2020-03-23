class AddGiverNameToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :giver_name, :string
  end
end
