class OrdersController < ApplicationController
  def create
    pizza_order_params = params[:pizzas]
    side_order_params = params[:sides]

    begin
      service = PizzaFactoryService.new
      order = service.create_order(pizza_order_params, side_order_params)

      render json: order, status: :created
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def restock
    type = params[:type]
    category = params[:category]
    quantity = params[:quantity].to_i

    service = PizzaFactoryService.new
    service.restock_inventory(type, category, quantity)

    render json: { message: "Inventory restocked successfully" }, status: :ok
  end
end
