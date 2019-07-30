# frozen_string_literal: true

require 'yaml'
require 'pry'
require_relative 'application/console'
require_relative 'application/bank_operations/account_processes'
require_relative 'application/bank_operations/card_processes'
require_relative 'application/bank_operations/money_transfer'
require_relative 'application/helpers/messages'
require_relative 'application/menu'

class Account
 attr_accessor :login, :name, :card, :password, :file_path, :user

 include Console
 include MainMenu
 include CardProcesses
 include MoneyTransfer
 include AccountProcesses

 def create
   loop do
     @user = User.new
     @user.set_credentials
     @errors = @user.errors
     break if @errors.empty?

     errors_output
     @errors = []
   end
   @card = []
   new_accounts = accounts << self
   @current_account = self
   write_to_file(new_accounts)
   main_menu
 end

 def load
   loop do
     return create_the_first_account if accounts.none?

     login = get_login
     password = get_password
     next puts 'There is no account with given credentials' unless account_exist(login, password)

     @current_account = accounts.select { |account| login == account.user.login }.first
     break
   end
   main_menu
 end
end
