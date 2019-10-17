# frozen_string_literal: true

module Validation
  POSITIVE_INFINITY = +1.0 / 0.0
  VALID_RANGE = {
      age: (23..89),
      login: (4..20),
      password: (6..30)
  }.freeze

  def name_validation(name)
    return if name != '' && name[0].upcase == name[0]

    @account.errors.push(I18n.t(:name_must_not_be_empty))
  end

  def validate_login(login)
    @login = login
    @account.errors.push(I18n.t(:login_present)) if @login.empty?
    @account.errors.push(I18n.t(:login_longer_than_4_symbols)) if @login.size < VALID_RANGE[:login].min
    @account.errors.push(I18n.t(:login_less_than_20_symbols)) if @login.size > VALID_RANGE[:login].max
    @account.errors.push(I18n.t(:account_exists)) if load_db.map(&:login).include? login
  end

  def account_exists?
    account.detect { |account_in_db| account_in_db.login == @login }
  end

  def password_validation(password)
    case password.length
    when 0
      @account.errors.push(I18n.t(:password_must_present))
    when 1..6
      @account.errors.push(I18n.t(:password_has_6_and_more_symbols))
    when 30..POSITIVE_INFINITY
      @account.errors.push(I18n.t(:password_has_30_and_less_symbols))
    end
  end

  def age_validation(age)
    return if age.is_a?(Integer) && age >= 23 && age <= 90

    @account.errors.push(I18n.t(:age_between_23_and_90))
  end

  def answer_validation(answer)
    answer.to_i <= @account.current_account.card.length && answer.to_i.positive?
  end

  def valid?
    @account.errors.empty?
  end
end
