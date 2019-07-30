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
 include Console
 include MainMenu
 include MoneyTransfer
 include CardProcesses
 include AccountProcesses
 include Messages

   attr_accessor :login, :name, :card, :password, :file_path

   def initialize
     @errors = []
     @file_path = 'accounts.yml'
   end

   def create
     loop do
       name_input
       age_input
       login_input
       password_input
       break if @errors.empty?

       errors_output
       @errors = []
     end

     @card = []
     new_accounts = accounts << self
     @current_account = self
     File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } # Storing
     main_menu
   end

   def load
     loop do
       return create_the_first_account if accounts.none?

       login = get_login
       password = get_password
       next puts 'There is no account with given credentials' unless account_exist(login, password)

       @current_account = accounts.select { |account| login == account.login }.first
       break
     end
     main_menu
   end

   private

   def name_input
     puts 'Enter your name'
     @name = gets.chomp
     unless @name != '' && @name[0].upcase == @name[0]
       @errors.push('Your name must not be empty and starts with first upcase letter')
     end
   end

   def login_input
     puts 'Enter your login'
     @login = gets.chomp
     @errors.push('Login must present') if @login == ''

     @errors.push('Login must be longer then 4 symbols') if @login.length < 4

     @errors.push('Login must be shorter then 20 symbols') if @login.length > 20

     @errors.push('Such account is already exists') if accounts.map(&:login).include? @login
   end

   def password_input
     puts 'Enter your password'
     @password = gets.chomp
     @errors.push('Password must present') if @password == ''

     @errors.push('Password must be longer then 6 symbols') if @password.length < 6

     @errors.push('Password must be shorter then 30 symbols') if @password.length > 30
   end

   def age_input
     puts 'Enter your age'
     @age = gets.chomp
     if @age.to_i.is_a?(Integer) && @age.to_i >= 23 && @age.to_i <= 90
       @age = @age.to_i
     else
       @errors.push('Your Age must be greeter then 23 and lower then 90')
     end
   end
 end