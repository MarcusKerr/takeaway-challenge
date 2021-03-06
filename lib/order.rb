# Holds order summary
# Caluculates total
# Sends text messaage
require "date"
require "twilio-ruby"
require_relative "menu"
class Order
  attr_reader :summary

  def initialize(menu_class = Menu.new, client_object = Twilio::REST::Client)
    reset
    @menu = menu_class
    account_sid = "AC27bbc0ac1d8220509171870f32e122f9"
    auth_token = "635ff5061dd4d33d0c4159400948205b"
    
    # Initialize Twilio Client
    @client = client_object.new account_sid, auth_token
  end

  def add(dish, quantity)
    fail "Select dish from menu" unless @menu.menu.any? { |hash| hash[:name] == dish }
    @summary << { name: dish, quantity: quantity }
  end

  def total
    @total = 0
    @summary.each do |ordered_dish|
      @menu.menu.each do |dish|
        if ordered_dish[:name] == dish[:name]
          @total += (dish[:price] * ordered_dish[:quantity]) 
        end 
      end 
    end
    return @total
  end
  def confirm
    fail "Must select a dish" if @summary.empty?
    total
    confirmation_message
    reset
  end

  def confirmation_message
    @client.messages.create(
      body: "Thank you! Your order costs £#{total} and will be delivered before #{delivery_time}",
      to: "+447476311101",
      from: "+447480488332"
    )
  end

  def reset
    @summary = []
    @total = 0
  end 

  def delivery_time
    time = Time.new
    (time + (1 * 60 * 60)).strftime("at %I:%M%p") 
  end 

  def show_client 
    puts @client
  end 
  private :reset, :delivery_time
end


