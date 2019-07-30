# frozen_string_literal: true

module MainMenu
  def main_menu
    commands = {
        SC: Proc.new{ show_cards },
        CC: Proc.new{ create_card },
        DC: Proc.new{ destroy_card },
        PM: Proc.new{ put_money },
        WM: Proc.new{ withdraw_money },
        SM: Proc.new{ send_money },
        DA: Proc.new{ destroy_account; exit },
        exit: Proc.new{ exit; break }
    }

    loop do
      puts "\nWelcome, #{@current_account.name}"
      puts 'If you want to:'
      puts '- show all cards - enter SC'
      puts '- create card - enter CC'
      puts '- destroy card - enter DC'
      puts '- put money on card - enter PM'
      puts '- withdraw money on card - enter WM'
      puts '- send money to another card  - enter SM'
      puts '- destroy account - enter DA'
      puts '- exit from account - enter exit'

      command = gets.chomp

      if commands.key?(command.to_sym)
        commands[command.to_sym].call
      else
        puts "Wrong command. Try again!\n"
      end
    end
  end
end