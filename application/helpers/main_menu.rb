# frozen_string_literal: true

require_relative 'ui'

module MainMenu
  include UI

  def choose_card
    loop do
      puts I18n.t('Choose the card for your operation:')
      break unless show_cards_for_operations

      exit_message
      choice = gets.chomp
      break if choice == 'exit'
      return puts I18n.t('ERROR.wrong_number') unless answer_validation(choice)

      return @account.current_account.card[choice.to_i - 1]
    end
  end

  def choose_recipient_card
    loop do
      puts I18n.t(:enter_recipient_card)
      card_number = gets.chomp
      return puts I18n.t('enter_correct_number') unless card_number.length == 16

      all_cards = accounts.map(&:card).flatten
      recipient_card = all_cards.select { |card| card.number == card_number }.first
      return puts "There is no card with number #{card_number}\n" if recipient_card.nil?

      return recipient_card
    end
  end

  def amount_input
    loop do
      puts I18n.t('input_the_amount')
      amount = gets.chomp

      return puts I18n.t('ERROR.correct_amount') unless amount.to_i.positive?

      return amount
    end
  end

  def login_input
    puts I18n.t('ASK.login')
    gets.chomp
  end

  def password_input
    puts I18n.t('ASK.password')
    gets.chomp
  end
end
