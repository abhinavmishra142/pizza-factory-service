class PizzaFactoryService
  # Static Data as Constants
  PIZZA_PRICES = {
    "Deluxe Veggie" => { "Regular" => 150, "Medium" => 200, "Large" => 325 },
    "Cheese and corn" => { "Regular" => 175, "Medium" => 375, "Large" => 475 },
    "Paneer Tikka" => { "Regular" => 160, "Medium" => 290, "Large" => 340 },
    "Non-Veg Supreme" => { "Regular" => 190, "Medium" => 325, "Large" => 425 },
    "Chicken Tikka" => { "Regular" => 210, "Medium" => 370, "Large" => 500 },
    "Pepper Barbecue Chicken" => { "Regular" => 220, "Medium" => 380, "Large" => 525 }
  }.freeze

  TOPPING_PRICES = {
    "Black olive" => 20, "Capsicum" => 25, "Paneer" => 35, "Mushroom" => 30, "Fresh tomato" => 10,
    "Chicken tikka" => 35, "Barbeque chicken" => 45, "Grilled chicken" => 40, "Extra cheese" => 35
  }.freeze

  SIDES_PRICES = {
    "Cold drink" => 55, "Mousse cake" => 90
  }.freeze

  def initialize
    # Inventory (Dynamic)
    @inventory = {
    pizzas: {
      "Deluxe Veggie" => 50, "Cheese and corn" => 50, "Paneer Tikka" => 50,
      "Non-Veg Supreme" => 50, "Chicken Tikka" => 50, "Pepper Barbecue Chicken" => 50
    },
    crusts: {
      "New hand tossed" => 100, "Wheat thin crust" => 100, "Cheese Burst" => 100, "Fresh pan pizza" => 100
    },
    toppings: {
      "Black olive" => 20, "Capsicum" => 25, "Paneer" => 35, "Mushroom" => 30, "Fresh tomato" => 10,
      "Chicken tikka" => 35, "Barbeque chicken" => 45, "Grilled chicken" => 40, "Extra cheese" => 35
    },
    sides: {
      "Cold drink" => 30, "Mousse cake" => 20
    }
  }
  end

  # Method to restock inventory
  # In the restock_inventory method:
  def restock_inventory(type, category, quantity)
    if @inventory[category.to_sym].nil?
      raise "Invalid category: #{category}"
    end

    if @inventory[category.to_sym][type].nil?
      raise "Invalid type: #{type} for category #{category}"
    end

    @inventory[category.to_sym][type] += quantity
  end

  # Method to check inventory for availability of ingredients
  def check_inventory(order)
    order[:pizzas].each do |pizza|
      raise "Not enough inventory to fulfill the order" unless @inventory[:pizzas][pizza[:type]] > 0
      raise "Not enough crust inventory" unless @inventory[:crusts][pizza[:crust]] > 0

      pizza[:toppings].each do |topping|
        topping_name = topping[:name]
        raise "Not enough inventory for topping #{topping_name}" if @inventory[:toppings][topping_name].nil? || @inventory[:toppings][topping_name] <= 0
      end
    end

    order[:sides].each do |side|
      raise "Not enough inventory for side #{side[:name]}" if @inventory[:sides][side[:name]] <= 0
    end
  end

  # Method to create an order
  def create_order(pizza_order_params, side_order_params)
    # Check for invalid toppings
    check_for_invalid_toppings(pizza_order_params)

    # Calculate total amount
    total_amount = 0
    pizzas = []

    pizza_order_params.each do |pizza|
      pizza_total = calculate_price(pizza)
      total_amount += pizza_total
      pizzas << pizza
    end

    sides = []
    side_order_params.each do |side|
      total_amount += calculate_side_price(side)
      sides << side
    end

    { total_amount: total_amount, pizzas: pizzas, sides: sides }
  end

  private

  # Helper method to check invalid toppings based on pizza type
  def check_for_invalid_toppings(order)
    order.each do |pizza|
      if pizza[:type] == "Vegetarian"
        pizza[:toppings].each do |topping|
          raise "Invalid topping #{topping[:name]}" if non_veg_topping?(topping)
        end
      elsif pizza[:type] == "Non-Vegetarian"
        pizza[:toppings].each do |topping|
          raise "Invalid topping #{topping[:name]}" if veg_topping?(topping)
        end
      end
    end
  end

  # Helper method to check if a topping is non-vegetarian
  def non_veg_topping?(topping)
    [ "Chicken tikka", "Barbeque chicken", "Grilled chicken" ].include?(topping[:name])
  end

  # Helper method to check if a topping is vegetarian
  def veg_topping?(topping)
    [ "Paneer" ].include?(topping[:name])
  end

  # Helper method to calculate price for a pizza
  def calculate_price(pizza)
    base_price = pizza_base_price(pizza[:type], pizza[:size])
    topping_price = calculate_topping_price(pizza)

    # Set topping price to 0 if it's a large pizza with more than 2 toppings
    if pizza[:size] == "Large" && pizza[:toppings].size > 2
      topping_price = 0
    end

    base_price + topping_price
  end


  # Helper method to get base price for a pizza
  def pizza_base_price(type, size)
    Rails.logger.debug("PIZZA_PRICES: #{PIZZA_PRICES.inspect}") # Add this line to debug
    base_price = PIZZA_PRICES[type][size]
    raise "Base price for #{type} with size #{size} not found!" if base_price.nil?
    base_price
  end


  # Helper method to calculate topping price
  def calculate_topping_price(pizza)
    pizza[:toppings].sum { |topping| TOPPING_PRICES[topping[:name]] || 0 }
  end

  # Helper method to calculate price for sides
  def calculate_side_price(side)
    SIDES_PRICES[side[:name]] || 0
  end
end
