class OrdersController < ApplicationController
  def new
    @order = Order.new(product: Product.find(params[:product_id]))
  end

  def create
    oparams = order_params
    if oparams[:is_gift] == "1"
      child = Child.find_by(child_params)
      last_order = Order.where(child:child).order(created_at: :desc).first
      oparams[:address] = last_order&.address || ""
      oparams[:zipcode] = last_order&.zipcode || ""
    else
      child = Child.find_or_create_by(child_params)
    end
    @order = Order.create(oparams.except(:is_gift).merge(child: child, user_facing_id: SecureRandom.uuid[0..7]))
    # TODO: should introduce clientside validation for fields and their coherence
    if @order.valid?
      Purchaser.new.purchase(@order, credit_card_params)
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    # TODO: should add graceful forwarding to not-found page for unknown orders
    # TODO: security concern -- reconsider allowing order lookup by raw db id 
    @order = Order.find_by(id: params[:id]) || Order.find_by(user_facing_id: params[:id])
  end

private

  def order_params
    params.require(:order).permit(:shipping_name, :product_id, :zipcode, :address, :is_gift, :giver_name, :giver_message).merge(paid: false)
  end

  def child_params
    {
      full_name: params.require(:order)[:child_full_name],
      parent_name: params.require(:order)[:shipping_name],
      # TODO: the date parse blows up with bad data... should add clientside 
      #       datepicker+validation (or at least serverside validation with a graceful failure) 
      birthdate: Date.parse(params.require(:order)[:child_birthdate]), 
    }
  end

  def credit_card_params
    params.require(:order).permit( :credit_card_number, :expiration_month, :expiration_year)
  end
end
