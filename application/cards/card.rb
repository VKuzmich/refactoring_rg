# frozen_string_literal: true

class Card
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
