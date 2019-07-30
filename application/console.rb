# frozen_string_literal: true

module Console
  def console
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - enter `create`'
    puts '- If you want to load account - enter `load`'
    puts '- If you want to exit - enter `exit`'

    choose = gets.chomp

    case choose
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
      exit if choice == 'exit'
      return puts "You entered wrong number!\n" unless answer_validation(choice)

      return @current_account.card[choice.to_i - 1]
    end
  end

  def get_amount
    loop do
      puts 'Input the amount'
      amount = gets.chomp
      return 'You must input correct amount of money' unless amount.to_i.positive?

      return amount.to_i
    end
  end

  def get_login
    puts 'Enter your login'
    login = gets.chomp
  end

  def get_password
    puts 'Enter your password'
    password = gets.chomp
  end
end
