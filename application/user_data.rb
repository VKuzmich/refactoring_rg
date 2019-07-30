# frozen_string_literal: true

require_relative '../application/validation'

module UserData
  include Validation

  def user_name
    puts 'Enter your name'
    name = gets.chomp
    name_validation(name)
    @account.name = name if valid?
  end

  def user_login
    puts 'Enter your login'
    login = gets.chomp
    login_validation(login)
    @account.login = login if valid?
  end

  def user_password
    puts 'Enter your password'
    password = gets.chomp
    password_validation(password)
    @account.password = password if valid?
  end

  def user_age
    puts 'Enter your age'
    age = gets.chomp.to_i
    age_validation(age)
    @account.age = age if valid?
  end

  def set_credentials
    user_name
    user_age
    user_login
    user_password
  end
end
