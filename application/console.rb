# frozen_string_literal: true

# require_relative 'dependencies'
require_relative 'cards/card'
require_relative 'helpers/main_menu'
require_relative 'bank_operations/account_processes'
require_relative 'bank_operations/card_processes'
require_relative 'bank_operations/money_transfer'
require_relative 'helpers/user_info'
require_relative 'helpers/file_manager'

class Console
  include MainMenu
  include AccountProcesses
  include CardProcesses
  include UserInfo
  include FileManager
  include MoneyTransfer

  attr_accessor :account

  def initialize
    @account = Account.new
  end

  def run
    console
  end
end
