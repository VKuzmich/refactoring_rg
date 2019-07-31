# frozen_string_literal: true

module Validation
  POSITIVE_INFINITY = +1.0 / 0.0

  def name_validation(name)
    return if name != '' && name[0].upcase == name[0]

    @account.errors.push('Your name must not be empty and starts with first upcase letter')
  end

  def login_validation(login)
    case login.length
    when 0
      @account.errors.push('Login must present')
    when 1..4
      @account.errors.push('Login must be longer then 4 symbols')
    when 20..POSITIVE_INFINITY
      @account.errors.push('Login must be shorter then 20 symbols')
    end

    @account.errors.push('Such account is already exists') if accounts.map(&:login).include? login
  end

  def password_validation(password)
    case password.length
    when 0
      @account.errors.push('Password must present')
    when 1..6
      @account.errors.push('Password must be longer then 6 symbols')
    when 30..POSITIVE_INFINITY
      @account.errors.push('Password must be shorter then 30 symbols')
    end
  end

  def age_validation(age)
    return if age.is_a?(Integer) && age >= 23 && age <= 90

    @account.errors.push('Your Age must be greeter then 23 and lower then 90')
  end

  def answer_validation(answer)
    answer.to_i <= @account.current_account.card.length && answer.to_i.positive?
  end

  def valid?
    @account.errors.empty?
  end
end
