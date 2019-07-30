# frozen_string_literal: true

class Card
  def card_info
    {
        type: @type,
        number: @number,
        balance: @balance
    }
  end

  def generate_number
    Array.new(16) { rand(10) }.join
  end
end
