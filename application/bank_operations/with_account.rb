# frozen_string_literal: true

require_relative '../helpers/database'

module WithAccount
  def update_accounts(updated_account)
    write_to_file(update_info(updated_account))
  end

  def update_account_by_card(*cards)
    updated_account = ''
    updating_account(cards)
    update_accounts(updated_account)
  end

  def account_exist(login, password)
    load_db.map do |account|
      { login: account.login, password: account.password }
    end.include?(login: login, password: password)
  end

  private

  def updating_account(cards)
    load_db.each do |account|
      updating_through_card(account, cards)
    end
  end

  def updating_through_card(account, cards)
    account.card.each do |account_card|
      allowance_updating(account, account_card, cards)
    end
  end

  def allowance_updating(_account, account_card, cards)
    cards.each do |card|
      next unless account_card.number == card.number

      account_card.balance = card.balance
    end
  end

  def update_info(updated_account)
    load_db.map do |account|
      account.login == updated_account.login ? updated_account : account
    end
  end
end
