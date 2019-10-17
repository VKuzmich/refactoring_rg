# frozen_string_literal: true

require_relative 'dependencies'

class ConsoleHelper
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

  def destroying_process
    new_accounts = []
    load_db.each do |account| new_accounts.push(account) unless
        account.login == @account.current_account.login
    end
    write_to_file(new_accounts)
  end

  def checking_login(login)
    @account.current_account = load_db.select { |account| login == account.login }.first
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

  def new_account_created
    @account.current_account = @account
    write_to_file(load_db << @account)
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

  # def before_destroying(new_accounts)
  #   accounts.each do |account|
  #     new_accounts.push(account) unless account.login == @account.current_account.login
  #   end
  # end

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
