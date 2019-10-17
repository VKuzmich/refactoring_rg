# frozen_string_literal: true

require_relative '../validation'

module UserInfo
  include Validation

  def user_name
    name = enter_name
    name_validation(name)
    @account.name = name if valid?
  end

  def user_login
    login = enter_login
    login_validation(login)
    @account.login = login if valid?
  end

  def user_password
    password = enter_password
    password_validation(password)
    @account.password = password if valid?
  end

  def user_age
    age = enter_age
    age_validation(age)
    @account.age = age if valid?
  end

  def user_inputs
    user_name
    user_age
    user_login
    user_password
  end

  private

  def enter_age
    puts I18n.t('ASK.age')
    gets.chomp.to_i
  end

  def enter_password
    puts I18n.t('ASK.password')
    gets.chomp
  end

  def enter_login
    puts I18n.t('ASK.login')
    gets.chomp
  end

  def enter_name
    puts I18n.t('ASK.name')
    gets.chomp
  end
end
