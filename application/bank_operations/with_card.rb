# frozen_string_literal: true

require_relative '../cards/card_usual'
require_relative '../cards/card_capitalist'
require_relative '../cards/card_virtual'
require_relative 'with_account'
require_relative '../helpers/messages'
require_relative '../validation'

module WithCard
  include Messages
  include Database
  include Validation


  def create_card
    loop do
      create_card_message
      cardtype = gets.chomp
      card = generate_card(cardtype)
      return puts "Wrong card type. Try again!\n" if card.nil?

      cards = @account.current_account.card << card
      @account.current_account.card = cards
      update_accounts(@account.current_account)
      break
    end
  end

  def destroy_card
    loop do
      puts 'If you want to delete:'
      break unless show_cards_for_operations

      exit_message
      choice = gets.chomp
      break if choice == 'exit'

      return puts "You entered wrong number!\n" unless answer_validation(choice)

      puts "Are you sure you want to delete #{@account.current_account.card[choice.to_i - 1].number}?[y/n]"
      confirmation = gets.chomp
      return unless confirmation == 'y'

      @account.current_account.card.delete_at(choice.to_i - 1)
      update_accounts(@account.current_account)
      break
    end
  end

  def show_cards
    return puts "There is no active cards!\n" unless cards

    @account.current_account.card.each do |card|
      puts "- #{card.number}, #{card.type}"
    end
  end

  def show_cards_for_operations
    return puts "There is no active cards!\n" unless cards

    @account.current_account.card.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
  end

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
