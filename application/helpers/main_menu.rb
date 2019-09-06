# frozen_string_literal: true

require_relative 'ui'

module MainMenu
  include UI

  def choose_card
    loop do
      puts 'Choose the card for your operation:'
      break unless show_cards_for_operations

      exit_message
      choice = gets.chomp
      break if choice == 'exit'
      return puts "You entered wrong number!\n" unless answer_validation(choice)

      return @account.current_account.card[choice.to_i - 1]
    end
  end

  def choose_recipient_card
    loop do
      puts 'Enter the recipient card:'
      card_number = gets.chomp
      return puts 'Please, input correct number of card' unless card_number.length == 16

      all_cards = accounts.map(&:card).flatten
      recipient_card = all_cards.select { |card| card.number == card_number }.first
      return puts "There is no card with number #{card_number}\n" if recipient_card.nil?

      return recipient_card
    end
  end

  def amount_input
    loop do
      puts 'Input the amount'
      amount = gets.chomp

      return puts 'You must input correct amount of money' unless amount.to_i.positive?

      return amount
    end
  end

  def login_input
    puts 'Enter your login'
    gets.chomp
  end

  def password_input
    puts 'Enter your password'
    gets.chomp
  end
end
