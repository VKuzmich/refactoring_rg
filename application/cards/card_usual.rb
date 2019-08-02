# frozen_string_literal: true

require_relative 'card'

class CardUsual < Card
  attr_accessor :number, :balance, :type

  def initialize
    @type = 'usual'
    @number = generate_number
    @balance = 50.00
  end

  def withdraw_tax(amount)
    amount * 0.05
  end

  def put_tax(amount)
    amount * 0.02
  end

  def sender_tax(_amount)
    20
  end
end
