# frozen_string_literal: true

require_relative 'messages'

module MainMenu
  include Messages

  def console
    console_message
    choice = gets.chomp

    case choice
    when 'create' then create
    when 'load'   then load
    else               exit
    end
  end

  def commands
    {
        SC: proc { show_cards },
        CC: proc { create_card },
        DC: proc { destroy_card },
        PM: proc { put_money },
        WM: proc { withdraw_money },
        SM: proc { send_money },
        DA: proc { destroy_account; exit }
    }
  end

  def main_menu
    loop do
      main_menu_message
      command = gets.chomp

      if commands.key?(command.to_sym)
        commands[command.to_sym].call
      elsif command == 'exit'
        exit
        break
      else
        puts "Wrong command. Try again!\n"
      end
    end
  end

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

  def create
    loop do
      set_info
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
end
