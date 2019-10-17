# frozen_string_literal: true

require_relative 'ui'

module MainMenu
  include UI

  def choose_card
    message_of_card_choice
    return unless show_cards_for_operations

    stop_processing
  end

  def choose_recipient_card
    entering_card_number
    return puts I18n.t('enter_correct_number') unless entering_card_number.length == 16

    correct_number_card(entering_card_number)
    validate_correct_number
  end

  def amount_input
    amount_input_message
    return puts I18n.t('ERROR.correct_amount') unless amount_input_message.to_i.positive?

    amount_input_message
  end

  def login_input
    puts I18n.t('ASK.login')
    gets.chomp
  end

  def password_input
    puts I18n.t('ASK.password')
    gets.chomp
  end

  private

  def stop_processing
    exit_message
    exit_or_wrong_number
  end

  def validate_correct_number
    return puts "There is no card with number #{entering_card_number}\n" if
        correct_number_card(entering_card_number).nil?

    correct_number_card(entering_card_number)
  end

  def want_to_exit
    puts I18n.t('exit')
    gets.chomp
  end

  def exit_or_wrong_number
    choice = gets.chomp
    return if choice == I18n.t('exit')

    return puts I18n.t('ERROR.wrong_number') unless answer_validation(choice)

    @account.current_account.card[choice.to_i - 1]
  end

  def amount_input_message
    puts I18n.t(:input_the_amount)
    gets.chomp
  end

  def entering_card_number
    puts I18n.t(:enter_recipient_card)
    gets.chomp
  end

  def correct_number_card(card_number)
    accounts.map(&:card).flatten.select { |card| card.number == card_number }.first
  end
end
