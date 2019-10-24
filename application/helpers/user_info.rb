# frozen_string_literal: true

# require_relative '../validation'

module UserInfo
  def user_name
    enter_name
  end

  def user_login
    enter_login
  end

  def user_password
    enter_password
  end

  def user_age
    enter_age
  end

  def enter_age
    puts I18n.t('ASK.age')
    user_input.to_i
  end

  def enter_password
    puts I18n.t('ASK.password')
    user_input
  end

  def enter_login
    puts I18n.t('ASK.login')
    user_input
  end

  def enter_name
    puts I18n.t('ASK.name')
    user_input
  end
end
