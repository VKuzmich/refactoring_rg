# frozen_string_literal: true

class CreditCards
  attr_accessor :type, :number, :balance, :card_types

  def initialize
    @type = ''
    @number = 0
    @balance = 0
    @card_types = {
        usual: 50.00,
        capitalist: 100.00,
        virtual: 150.00
    }
  end

  def generate_card(type)
    @type = type
    @number = generate_number
    @balance = @card_types[type.to_sym]
  end

  private

  def generate_number
    Array.new(16) { rand(10) }.join
  end
  def card_info
    {
        type: @type,
        number: @number,
        balance: @balance
    }
  end
end
