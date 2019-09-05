# frozen_string_literal: true

require_relative 'dependencies'

class Console
  include MainMenu
  include WithAccount
  include WithCard
  include UserInfo
  include Database
  include WithMoney
  include Messages
  include UI

  EXIT = 'exit'.freeze

  attr_accessor :account

  def initialize
    @account = Account.new
  end

  def console
    console_message
    choice = gets.chomp

    case choice
    when 'create' then create
    when 'load'   then load
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

  def set_account_info
    {
        name: enter(I18n.t('ASK.name')),
        age: enter(I18n.t('ASK.age')),
        login: enter(I18n.t('ASK.login')),
        password: enter(I18n.t('ASK.password'))
    }
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
    gets.chomp == 'y' ? create : console
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

  def run
    console
  end
end
