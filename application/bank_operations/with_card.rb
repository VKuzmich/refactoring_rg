# frozen_string_literal: true

require_relative '../cards/card_usual'
require_relative '../cards/card_capitalist'
require_relative '../cards/card_virtual'
require_relative 'with_account'
require_relative '../validation'
require_relative '../helpers/ui'

module WithCard
  include Database
  include Validation
  include UI


  def card_present(card)
    @account.current_account.card.include? card
  end

  def cards
    @account.current_account.card.any?
  end

  def generate_card(type)
    case type
    when 'usual'
      CardUsual.new
    when 'capitalist'
     CardCapitalist.new
    when 'virtual'
      CardVirtual.new
    end
  end
end
