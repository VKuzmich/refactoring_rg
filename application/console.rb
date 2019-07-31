# frozen_string_literal: true

require_relative 'dependencies'

class Console
  include MainMenu
  include WithAccount
  include WithCard
  include UserInfo
  include Database
  include WithMoney

  attr_accessor :account

  def initialize
    @account = Account.new
  end

  def run
    console
  end
end
