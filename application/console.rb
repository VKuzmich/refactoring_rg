# frozen_string_literal: true

require_relative 'dependencies'

class Console
  include MainMenu
  include WithAccount
  include WithCard
  include UserInfo
  include Database
  include WithMoney
  include UI

  attr_accessor :account

  def initialize
    @account = Account.new
  end

  def console
    console_message
    choice = gets.chomp

    case choice
    when COMMANDS[:create] then create
    when COMMANDS[:load]   then load
    else               exit
    end
  end

  def create
    loop do
      user_info
      break if valid?

      errors_message
      @account.errors = []
    end
    new_accounts = accounts << @account
    @account.current_account = @account
    write_to_file(new_accounts)
    main_menu
  end


  def load
    loop do
      return create_the_first_account if accounts.none?

      login = login_input
      password = password_input
      next puts 'There is no account with given credentials' unless account_exist(login, password)

      @account.current_account = accounts.select { |account| login == account.login }.first
      break
    end
    main_menu
  end

  def create_the_first_account
    puts "there are no active accounts, type 'y' if you want to create one"
    gets.chomp == YES ? create : console
  end

  def main_menu
    loop do
      main_menu_message
      command = gets.chomp

      case command
      when COMMANDS[:show_cards]      then show_cards
      when COMMANDS[:create_card]     then create_card
      when COMMANDS[:destroy_card]    then destroy_card
      when COMMANDS[:put_money]       then put_money
      when COMMANDS[:withdraw_money]  then withdraw_money
      when COMMANDS[:send_money]      then send_money
      when COMMANDS[:destroy_account] then return destroy_account
      when EXIT                       then break exit
      else
        puts "Wrong command. Try again!\n"
      end
    end
  end

  def show_cards
    return puts "There is no active cards!\n" unless cards

    @account.current_account.card.each do |card|
      puts "- #{card.number}, #{card.type}"
    end
  end

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
      break if choice == EXIT

      return puts "You entered wrong number!\n" unless answer_validation(choice)

      puts "Are you sure you want to delete #{@account.current_account.card[choice.to_i - 1].number}?[y/n]"
      confirmation = gets.chomp
      return unless confirmation == YES

      @account.current_account.card.delete_at(choice.to_i - 1)
      update_accounts(@account.current_account)
      break
    end
  end

  def put_money
    current_card = choose_card
    until current_card.nil?
      amount = amount_input.to_i
      break if amount.zero?

      return high_tax unless current_card.put_tax(amount) < amount

      current_card.balance = current_card.balance + amount - current_card.put_tax(amount)
      update_accounts(@account.current_account)
      put_money_msg(amount, current_card)
      break
    end
  end

  def withdraw_money
    current_card = choose_card
    until current_card.nil?
      amount = amount_input.to_i
      break if amount.zero?

      return insufficient_funds if money_left(current_card, amount).negative?

      update_accounts(@account.current_account)
      withdraw_money_msg(amount, current_card)
      break
    end
  end

  def send_money
    sender_card = choose_card
    recipient_card = choose_recipient_card

    until sender_card.nil? || recipient_card.nil?
      amount = amount_input.to_i
      break if amount.zero?

      sender_card.balance = sender_card.balance - amount - sender_card.sender_tax(amount)
      recipient_card.balance = recipient_card.balance + amount - recipient_card.put_tax(amount)

      return insufficient_funds unless sender_card.balance.positive? ||
          recipient_card.put_tax(amount) < amount

      if card_present(recipient_card)
        update_account_by_card(recipient_card, sender_card)
      else
        update_account_by_card(recipient_card)
        update_account_by_card(sender_card)
      end
      send_money_sender_msg(amount, sender_card)
      send_money_recipient_msg(amount, recipient_card)
      break
    end
  end

  def destroy_account
    puts 'Are you sure you want to destroy account?[y/n]'
    answer = gets.chomp
    return unless answer == YES

    new_accounts = []
    accounts.each do |ac|
      new_accounts.push(ac) unless ac.login == @account.current_account.login
    end
    write_to_file(new_accounts)
  end

  def run
    console
  end

  private

  def show_cards_for_operations
    return puts "There is no active cards!\n" unless cards

    @account.current_account.card.each_with_index do |card, index|
      puts "- #{card.number}, #{card.type}, press #{index + 1}"
    end
  end

  def money_left(current_card, amount)
    current_card.balance - amount * (1 + current_card.withdraw_tax)
  end

end
