# frozen_string_literal: true

require_relative '../helpers/database'

module WithAccount
  def accounts
    return [] unless File.exist?(PATH)

    YAML.load_file(PATH)
  end

  def update_accounts(updated_account)
    new_accounts = accounts.map do |account|
      account.login == updated_account.login ? updated_account : account
    end
    write_to_file(new_accounts)
  end

  def update_account_by_card(*cards)
    updated_account = ''
    accounts.each do |account|
      account.card.each do |account_card|
        cards.each do |card|
          next unless account_card.number == card.number

          account_card.balance = card.balance
          updated_account = account
        end
      end
    end
    update_accounts(updated_account)
  end

  def account_exist(login, password)
    accounts.map do |account|
      { login: account.login, password: account.password }
    end.include?(login: login, password: password)
  end
end
