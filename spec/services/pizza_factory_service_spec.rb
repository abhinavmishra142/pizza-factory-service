require 'rails_helper'

RSpec.describe PizzaFactoryService, type: :service do
  let(:service) { PizzaFactoryService.new }

  describe '#create_order' do
    it 'calculates the total amount correctly' do
      pizza_order_params = [
        { type: 'Deluxe Veggie', size: 'Medium', crust_type: 'Wheat thin crust', toppings: [ { name: 'Capsicum' } ] },
        { type: 'Chicken Tikka', size: 'Large', crust_type: 'Cheese Burst', toppings: [ { name: 'Grilled chicken' } ] }
      ]
      side_order_params = [ { name: 'Cold drink' } ]

      order = service.create_order(pizza_order_params, side_order_params)

      expect(order[:total_amount]).to eq(820)  # Medium pizza + Large pizza + 1 side
    end


    xit 'raises an error if inventory is not available for a topping' do
      pizza_order_params = [
        { type: 'Deluxe Veggie', size: 'Medium', crust_type: 'Wheat thin crust', toppings: [ { name: 'Black olive' } ] }
      ]
      side_order_params = []

      # Simulate no inventory for 'Black olive'
      service.instance_variable_set(:@inventory, toppings: { 'Black olive' => 0 })

      expect { service.create_order(pizza_order_params, side_order_params) }.to raise_error('Not enough inventory for topping Black olive')
    end


    it 'validates business rules for vegetarian pizzas' do
      pizza_order_params = [
        { type: 'Vegetarian', size: 'Regular', crust_type: 'New hand tossed', toppings: [ { name: 'Chicken tikka' } ] }
      ]
      side_order_params = []

      expect { service.create_order(pizza_order_params, side_order_params) }.to raise_error('Invalid topping Chicken tikka')
    end
  end

  describe '#restock_inventory' do
    it 'restocks the inventory successfully' do
      service.restock_inventory('Black olive', :toppings, 10)
      expect(service.instance_variable_get(:@inventory)[:toppings]['Black olive']).to eq(30)
    end
  end
end
