# frozen_string_literal: true

require_relative 'card'

class CardVirtual < Card
  attr_accessor :number, :balance, :type

  def initialize
    @type = I18n.t(:Virtual)
    @number = generate_number
    @balance = 150.00
  end

  def withdraw_tax(amount)
    amount * 0.88
  end

  def put_tax(_amount)
    1
  end

  def sender_tax(_amount)
    1
  end
end
