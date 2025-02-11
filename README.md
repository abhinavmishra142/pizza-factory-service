# README

# Pizza Factory Service

A simple service that simulates an online pizza ordering system, handling pizza types, toppings, crusts, and sides. The service calculates total order costs, validates inventory, and ensures business rules for vegetarian and non-vegetarian pizza toppings are respected.

## Features

- **Order Management**: Create and manage pizza orders with different types, sizes, crusts, and toppings.
- **Inventory Management**: Check and restock pizza ingredients and sides.
- **Price Calculation**: Automatically calculates the total cost based on pizza type, size, and selected toppings. 
- **Business Rules**: Validates that vegetarian pizzas only have vegetarian toppings and vice versa.

## Technology Stack

- Ruby on Rails
- RSpec for testing
- Git for version control

### Prerequisites

Make sure you have the following installed on your system:

- Ruby (version 2.x or higher)
- Rails (version 5.x or higher)
- Bundler (for managing dependencies)



### Running the Service

To run the service, simply start your Rails server:


rails server

Running Tests
  To run the RSpec tests, execute the following command:


  bundle exec rspec
* ...
