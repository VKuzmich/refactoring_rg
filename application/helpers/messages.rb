# frozen_string_literal: true

module Messages
  def create_card_message
    puts 'You could create one of 3 card types'
    puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - enter `usual`'
    puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - enter `capitalist`'
    puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - enter `virtual`'
    puts '- For exit - enter `exit`'
  end

  def main_menu_message
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
  end

  def console_message
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - enter `create`'
    puts '- If you want to load account - enter `load`'
    puts '- If you want to exit - enter `exit` or anything else'
  end

  def exit_message
    puts "press `exit` to exit\n"
  end

  def errors_message
    @errors.each do |error|
      puts error
    end
  end
end
