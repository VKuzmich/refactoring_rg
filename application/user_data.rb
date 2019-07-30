# frozen_string_literal: true

require_relative '../application/validation'

module UserData
  include Validation

  def user_name
    puts 'Enter your name'
    name = gets.chomp
    @account.name = name if valid?
  end

  def user_login
    puts 'Enter your login'
    login = gets.chomp
    @account.login = login if valid?
  end

  def user_password
    puts 'Enter your password'
    password = gets.chomp
    @account.password = password if valid?
  end

  def user_age
    puts 'Enter your age'
    age = gets.chomp.to_i
    @account.age = age if valid?
  end

  def set_credentials
    user_name
    user_age
    user_login
    user_password
  end
end
