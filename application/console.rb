# frozen_string_literal: true

require_relative 'dependencies'

class Console < ConsoleHelper
  include MainMenu
  include WithAccount
  include UserInfo
  include Database
  include UI
  include Validation

  attr_accessor :account

  def initialize
    @account = Account.new
  end

  def console
    case choice_operations
    when COMMANDS[:create] then create
    when COMMANDS[:load]   then load
    else                        exit
    end
  end

  def create
    loop do
      user_inputs
      break if valid?

      errors_messages
      @account.errors = []
    end
    new_account_created
  end

  def load
    loop do
      return create_the_first_account if load_db.none?

      login = login_input
      password = password_input
      next puts I18n.t('Load.no_credentials') unless account_exist(login, password)

      checking_login(login)
      break
    end
    main_menu
  end

  def create_the_first_account
    puts I18n.t(:no_active_account_yet)
    gets.chomp == YES ? create : console
  end

  def main_menu
    loop do
      case choice_proposition
      when COMMANDS[:show_cards]      then show_cards
      when COMMANDS[:create_card]     then create_card
      when COMMANDS[:destroy_card]    then destroy_card
      when COMMANDS[:put_money]       then put_money
      when COMMANDS[:withdraw_money]  then withdraw_money
      when COMMANDS[:send_money]      then send_money
      when COMMANDS[:destroy_account] then return destroy_account
      when I18n.t(:exit)              then break exit
      else
        puts I18n.t(:wrong_command)
      end
    end
  end

  def show_cards
    return puts I18n.t('ERROR.no_active_cards') unless cards

    show_active_card
  end

  def create_card
    card = @account.create_new_card(choose_type_card)
    return puts I18n.t(:WRONG_CARD_TYPE) if card.nil?

    created_card(card)
  end

  def cards
    @account.current_account.card.any?
  end

  def destroy_card
    delete_message
    return unless show_cards_for_operations

    choice = after_entering_exit

    return if choice == I18n.t('yes')

    return puts I18n.t('ERROR.wrong_number') unless answer_validation(choice)

    return unless deleting_confirmation(after_entering_exit) == YES

    deleting_account(after_entering_exit)
  end

  def put_money
    current_card = choose_card

    return if current_card.nil?

    return if amount_input.to_i.zero?

    return high_tax unless current_card.put_tax(amount_input.to_i) < amount_input.to_i

    balance_account(amount_input.to_i, current_card)
  end

  def withdraw_money
    return if choose_card.nil?

    return if amount_input.to_i.zero?

    return insufficient_funds if money_left(choose_card, amount_input.to_i).negative?

    update_and_message(amount_input.to_i, choose_card)
  end

  def send_money
    return if cards_for_transfers.nil?

    return if amount_input.to_i.zero?

    transfer_balances(amount_input.to_i, *cards_for_transfers)

    return insufficient_funds unless allow_to_send(*cards_for_transfers)

    updating_messages(amount_input.to_i, *cards_for_transfers)
  end

  def destroy_account
    return unless message_before_destroying == YES

    destroying_process
  end

  def run
    console
  end
end
