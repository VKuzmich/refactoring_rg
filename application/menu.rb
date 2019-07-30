# frozen_string_literal: true

module MainMenu
  def commands
    {
        SC: proc { show_cards },
        CC: proc { create_card },
        DC: proc { destroy_card },
        PM: proc { put_money },
        WM: proc { withdraw_money },
        SM: proc { send_money },
        DA: proc { destroy_account; exit },
        exit: proc { exit; break }
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

      return @current_account.card[choice.to_i - 1]
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

  def get_amount
    loop do
      puts 'Input the amount'
      amount = gets.chomp
      return 'You must input correct amount of money' unless amount.to_i.positive?

      return amount.to_i
    end
  end

end