# frozen_string_literal: true

class Account
  attr_reader :name, :login, :password, :errors, :cards

  include Database

  VALID_RANGE = {
    age: (23..89),
    login: (4..20),
    password: (6..30)
  }.freeze

  def initialize(data)
    @name = data[:name]
    @age = data[:age].to_i
    @login = data[:login]
    @password = data[:password]
    @cards = []
    @errors = []
  end

  def valid?
    validation
    @errors.empty?
  end

  def destroy
    write_to_file(db_accounts.reject { |account| account.login == @login })
  end

  def create_new_type_card(type)
    case type
    when Card::CARD_TYPES[:usual]      then @cards << CardUsual.new(type)
    when Card::CARD_TYPES[:capitalist] then @cards << CardCapitalist.new(type)
    when Card::CARD_TYPES[:virtual]    then @cards << CardVirtual.new(type)
    end
  end

  def find_card_by_index(choice)
    @cards[choice.to_i - 1]
  end

  def self.find_account(user_data_inputs, account)
    account.detect do |db_acc|
      db_acc.login == user_data_inputs[:login] || db_acc.password == user_data_inputs[:password]
    end
  end

  def validation
    login_validation
    name_validation
    age_validation
    password_validation
  end

  def name_validation
    @errors << I18n.t(:name_must_not_be_empty) unless upcase?
  end

  def upcase?
    @name.capitalize[0] == @name[0]
  end

  def login_validation
    @errors << I18n.t(:login_present) if @login.empty?
    @errors << I18n.t(:login_longer_than_4_symbols) if @login.size < VALID_RANGE[:login].min
    @errors << I18n.t(:login_less_than_20_symbols) if @login.size > VALID_RANGE[:login].max
    @errors << I18n.t(:account_exists) if account_exists?
  end

  def password_validation
    @errors << I18n.t(:password_must_present) if @password.empty?
    @errors << I18n.t(:password_has_6_and_more_symbols) if @password.size < VALID_RANGE[:password].min
    @errors << I18n.t(:password_has_30_and_less_symbols) if @password.size > VALID_RANGE[:password].max
  end

  def age_validation
    @errors << I18n.t(:age_between_23_and_90) unless (VALID_RANGE[:age]).cover?(@age)
  end

  def account_exists?
    db_accounts.detect { |account_in_db| account_in_db.login == @login }
  end
end
