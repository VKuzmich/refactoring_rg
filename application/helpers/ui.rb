
module UI
  EXIT = 'exit'.freeze
  YES = 'y'.freeze

  COMMANDS = {
      create: 'create',
      load: 'load',
      show_cards: 'SC',
      create_card: 'CC',
      destroy_card: 'DC',
      put_money: 'PM',
      send_money: 'SM',
      withdraw_money: 'WM',
      destroy_account: 'DA'
  }.freeze


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

  def enter(message)
    puts message
    gets.chomp
  end

  def menu(name)
    puts I18n.t(:MAIN_MENU, name: name)
    gets.chomp
  end

  def wrong_command
    puts I18n.t('ERROR.wrong_command')
  end


  def show_errors
    @errors.each { |error| puts error }
    @errors = []
  end
  def create_card_message
    puts 'You could create one of 3 card types'
    puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card.'
    puts '5% tax on WITHDRAWING money. For creation this card - enter `usual`'
    puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card.'
    puts '4$ tax on WITHDRAWING money. For creation this card - enter `capitalist`'
    puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card.'
    puts '12% tax on WITHDRAWING money. For creation this card - enter `virtual`'
    puts '- For exit - enter `exit`'
  end

  def main_menu_message
    puts "\nWelcome, #{@account.current_account.name}"
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
    puts 'hello, we are RubyG bank!'
    puts '- If you want to create account - enter `create`'
    puts '- If you want to load account - enter `load`'
    puts '- If you want to exit - enter `exit`'
  end

  def exit_message
    puts "press `exit` to exit\n"
  end

  def errors_message
    @account.errors.each do |error|
      puts error
    end
  end

  def insufficient_funds
    puts "You don't have enough money on card for such operation"
  end

  def high_tax
    puts 'Tax is higher than input amount'
  end

  def withdraw_money_msg(amount, current_card)
    puts "Money #{amount} withdrawed from #{current_card.number}. " \
         "Money left: #{current_card.balance}. Tax: #{current_card.withdraw_tax(amount)}"
  end

  def put_money_msg(amount, current_card)
    puts "Money #{amount} was put on #{current_card.number}. " \
         "Balance: #{current_card.balance}. Tax: #{current_card.put_tax(amount)}"
  end

  def send_money_sender_msg(amount, current_card)
    puts "Money #{amount}$ were withdrawed from #{current_card.number}. " \
         "Balance: #{current_card.balance}. Tax: #{current_card.sender_tax(amount)}\n"
  end

  def send_money_recipient_msg(amount, current_card)
    puts "Money #{amount}$ were put on #{current_card.number}. " \
         "Balance: #{current_card.balance}. Tax: #{current_card.put_tax(amount)}\n"
  end

end