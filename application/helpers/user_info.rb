# frozen_string_literal: true

require_relative '../validation'

module UserInfo
  include Validation

  def user_name
    puts I18n.t("ASK.name")
    name = gets.chomp
    name_validation(name)
    @account.name = name if valid?
  end

  def user_login
    puts I18n.t('ASK.login')
    login = gets.chomp
    login_validation(login)
    @account.login = login if valid?
  end

  def user_password
    puts I18n.t('ASK.password')
    password = gets.chomp
    password_validation(password)
    @account.password = password if valid?
  end

  def user_age
    puts I18n.t('ASK.age')
    age = gets.chomp.to_i
    age_validation(age)
    @account.age = age if valid?
  end

  def user_info
    user_name
    user_age
    user_login
    user_password
  end
end
