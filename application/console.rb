# frozen_string_literal: true

require_relative 'dependencies'

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
