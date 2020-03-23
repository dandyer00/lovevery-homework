require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "#validations" do
    it "requires shipping_name" do
      order = Order.new(
        product: Product.new,
        shipping_name: nil,
        address: "123 Some Road",
        zipcode: "90210",
        user_facing_id: "890890908980980"
      )

      expect(order.valid?).to eq(false)
      expect(order.errors[:shipping_name].size).to eq(1)
    end

    it "requires address" do
      order = Order.new(
        product: Product.new,
        shipping_name: "Skippy",
        address: "",
        zipcode: "90210",
        user_facing_id: "890890908980980"
      )

      expect(order.valid?).to eq(false)
      expect(order.errors[:address].size).to eq(1)
    end

    it "requires zipcode" do
      order = Order.new(
        product: Product.new,
        shipping_name: "Skippy",
        address: "123 Some Road",
        zipcode: "",
        user_facing_id: "890890908980980"
      )

      expect(order.valid?).to eq(false)
      expect(order.errors[:zipcode].size).to eq(1)
    end
  end
end
