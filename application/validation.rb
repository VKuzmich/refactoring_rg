# frozen_string_literal: true

module Validation
  PositiveInfinity = +1.0 / 0.0

  def name_validation(name)
    unless name != '' && name[0].upcase == name[0]
      @errors.push('Your name must not be empty and starts with first upcase letter')
    end
  end

  def login_validation(login)
    case login.length
    when 0
      @errors.push('Login must present')
    when 1..4
      @errors.push('Login must be longer then 4 symbols')
    when 20..PositiveInfinity
      @errors.push('Login must be shorter then 20 symbols')
    end
  end

  def password_validation(password)
    case password.length
    when 0
      @errors.push('Password must present')
    when 1..6
      @errors.push('Password must be longer then 6 symbols')
    when 30..PositiveInfinity
      @errors.push('Password must be shorter then 30 symbols')
    end
  end

  def age_validation(age)
    return if age.is_a?(Integer) && age >= 23 && age <= 90

    @errors.push('Your Age must be greeter then 23 and lower then 90')
  end

  def answer_validation(answer)
    answer.to_i <= @current_account.card.length && answer.to_i.positive?
  end
end
