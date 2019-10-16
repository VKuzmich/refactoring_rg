
module UI
  EXIT = 'exit'.freeze
  YES = 'y'.freeze

  COMMANDS = {
      create: I18n.t(:create),
      load: I18n.t(:load),
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
    puts I18n.t('Message.create_card')
    puts I18n.t('Message.for_usual_card')
    puts I18n.t('Message.tax_for_withdrawing_usual')
    puts I18n.t('Message.for_capitalist_card')
    puts I18n.t('Message.tax_for_withdrawing_capitalist')
    puts I18n.t('Message.for_virtual_card')
    puts I18n.t('Message.tax_for_withdrawing_virtual')
    puts I18n.t('Message.for_exit_enter_exit')
  end

  def main_menu_message
    puts "\nWelcome, #{@account.current_account.name}"
    puts I18n.t('Main_menu.if_you_want_to')
    puts I18n.t('Main_menu.show_all_cards')
    puts I18n.t('Main_menu.create_card')
    puts I18n.t('Main_menu.destroy_card')
    puts I18n.t('Main_menu.money_on_card')
    puts I18n.t('Main_menu.withdraw_money')
    puts I18n.t('Main_menu.send_to_another_card')
    puts I18n.t('Main_menu.destroy_account')
    puts I18n.t('Main_menu.exit_from_account')
  end

  def console_message
    puts I18n.t('Greetings.greetings')
    puts I18n.t('Greetings.want_to_create_account')
    puts I18n.t('Greetings.want_to_load_account')
    puts I18n.t('Greetings.want_to_exit')
  end

  def exit_message
    puts I18n.t(:press_exit)
  end

  def errors_message
    @account.errors.each do |error|
      puts error
    end
  end

  def insufficient_funds
    puts I18n.t('ERROR.not_enough')
  end

  def high_tax
    puts I18n.t('Tax.tax_is_higher_than_input')
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

  def message_of_card_choice
    puts I18n.t('Choose the card for your operation:')
  end
end