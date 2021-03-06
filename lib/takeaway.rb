# Interface
require_relative "menu"
require_relative "order"

class Takeaway

  attr_reader :menu, :order

  def initialize(menu_class = Menu, order_class = Order)
    @menu = menu_class.new
    @order = order_class.new(@menu)
  end

  def print_menu
    @menu.print
  end

  def add_to_order(dish, quantity = 1)
    @order.add(dish, quantity)
  end 

  def order_total
    puts "£#{@order.total}"
  end

  def confirm
    @order.confirm
  end
end 
