# frozen_string_literal: true

require_relative '../helpers/file_manager'

module AccountProcesses
  def accounts
    return [] unless File.exist?('accounts.yml')

    YAML.load_file('accounts.yml')
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

  def create_the_first_account
    puts "there are no active accounts, type 'y' if you want to create one"
    gets.chomp == 'y' ? create : console
  end

  def destroy_account
    puts 'Are you sure you want to destroy account?[y/n]'
    answer = gets.chomp
    return unless answer == 'y'

    new_accounts = []
    accounts.each do |ac|
      new_accounts.push(ac) unless ac.login == @account.current_account.login
    end
    write_to_file(new_accounts)
  end

  def account_exist(login, password)
    accounts.map do |account|
      { login: account.login, password: account.password }
    end.include?(login: login, password: password)
  end
end
