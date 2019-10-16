# frozen_string_literal: true

require_relative 'dependencies'

class Console
  include MainMenu
  include WithAccount
  include WithCard
  include UserInfo
  include Database
  include UI

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
      user_info
      break if valid?

      errors_messages
      @account.errors = []
    end
    created_new_account
  end


  def load
    loop do
      return create_the_first_account if accounts.none?

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
    card = generate_card(choose_type_card)
    return puts I18n.t(:WRONG_CARD_TYPE) if card.nil?
    created_card(card)
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
    answer = message_before_destroying
    return unless answer == YES

    new_accounts = []
    before_destroying(new_accounts)
    write_to_file(new_accounts)
  end

  def run
    console
  end

  private

  def checking_login(login)
    @account.current_account = accounts.select { |account| login == account.login }.first
  end

  def choice_proposition
    main_menu_message
    gets.chomp
  end

  def choose_type_card
    create_card_message
    gets.chomp
  end

  def show_active_card
    cards = @account.current_account.card
    cards.each do |card|
      puts "- #{card.number}, #{card.type}"
    end
  end

  def choice_operations
    console_message
    gets.chomp
  end

  def created_new_account
    new_accounts = accounts << @account
    @account.current_account = @account
    write_to_file(new_accounts)
    main_menu
  end

  def allow_to_send(recipient_card, sender_card)
    sender_card.balance.positive? ||
        recipient_card.put_tax(amount_input.to_i) < amount_input.to_i
  end

  def update_and_message(amount, current_card)
    update_accounts(@account.current_account)
    withdraw_money_msg(amount, current_card)
  end

  def balance_account(amount, current_card)
    current_card.balance = current_card.balance + amount - current_card.put_tax(amount)
    update_accounts(@account.current_account)
    put_money_msg(amount, current_card)
  end

  def delete_message
    puts I18n.t(:want_to_delete)
  end

  def after_entering_exit
    exit_message
    gets.chomp
  end

  def message_before_destroying
    puts I18n.t('destroying_message')
    gets.chomp
  end

  def before_destroying(new_accounts)
    accounts.each do |ac|
      new_accounts.push(ac) unless ac.login == @account.current_account.login
    end
  end

  def deleting_confirmation(choice)
    puts "Are you sure you want to delete #{@account.current_account.card[choice.to_i - 1].number}?[y/n]"
    gets.chomp
  end

  def cards_for_transfers
    choose_card
    choose_recipient_card
  end

  def updating_messages(amount, recipient_card, sender_card)
    updating_account(recipient_card, sender_card)
    send_money_sender_msg(amount, sender_card)
    send_money_recipient_msg(amount, recipient_card)
  end

  def transfer_balances(amount, recipient_card, sender_card)
    sender_card.balance = sender_card.balance - amount - sender_card.sender_tax(amount)
    recipient_card.balance = recipient_card.balance + amount - recipient_card.put_tax(amount)
  end

  def updating_account(recipient_card, sender_card)
    return update_account_by_card(recipient_card, sender_card) if card_present(recipient_card)
    update_account_by_card(recipient_card)
    update_account_by_card(sender_card)
  end

  def deleting_account(choice)
    @account.current_account.card.delete_at(choice.to_i - 1)
    update_accounts(@account.current_account)
  end

  def created_card(card)
    cards = @account.current_account.card << card
    @account.current_account.card = cards
    update_accounts(@account.current_account)
  end

  def show_cards_for_operations
    return puts I18n.t('ERROR.no_active_cards') unless cards

    cards = @account.current_account.card
    cards.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
  end

  def money_left(current_card, amount)
    current_card.balance - amount * (1 + current_card.withdraw_tax)
  end
end
