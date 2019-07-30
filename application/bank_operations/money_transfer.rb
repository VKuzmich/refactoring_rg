# frozen_string_literal: true

require_relative 'card_processes'
require_relative '../helpers/messages'
require_relative '../validation'
require_relative '../console'

module MoneyTransfer
  include Messages
  include CardProcesses
  include Validation

  def withdraw_money
    current_card = choose_card

    loop do
      amount = get_amount

      new_balance = current_card.balance - amount - current_card.withdraw_tax(amount)
      return puts "You don't have enough money on card for such operation" unless new_balance.positive?

      current_card.balance = new_balance
      update_balance(current_card)
      update_accounts(@current_account)
      puts "Money #{amount} withdrawed from #{current_card.number}. Money left: #{current_card.balance}. Tax: #{current_card.withdraw_tax(amount)}"
      break
    end
  end

  def put_money
    current_card = choose_card
    loop do
      amount = get_amount

      return puts 'Tax is higher than input amount' unless current_card.put_tax(amount) < amount

      new_balance = current_card.balance + amount - current_card.put_tax(amount)
      current_card.balance = new_balance
      update_balance(current_card)
      update_accounts(@current_account)
      puts "Money #{amount} was put on #{current_card.number}. Balance: #{current_card.balance}. Tax: #{current_card.put_tax(amount)}"
      break
    end
  end

  def send_money
    sender_card = choose_card
    recipient_card = choose_recipient_card

    loop do
      amount = get_amount

      sender_balance = sender_card.balance - amount - sender_card.sender_tax(amount)
      recipient_balance = recipient_card.balance + amount - recipient_card.put_tax(amount)

      return puts "You don't have enough money on card for such operation" unless sender_balance.positive?

      return puts 'There is no enough money on sender card' unless recipient_card.put_tax(amount) < amount

      recipient_account = get_account_by_card(recipient_card)
      sender_card.balance = sender_balance
      recipient_card.balance = recipient_balance
      update_balance(sender_card)
      update_accounts(@current_account)
      update_balance(recipient_card)
      update_accounts(recipient_account)
      puts "Money #{amount}$ were withdrawed from #{sender_card.number}. Balance: #{sender_card.balance}. Tax: #{sender_card.sender_tax(amount)}\n"
      puts "Money #{amount}$ were put on #{recipient_card.number}. Balance: #{recipient_card.balance}. Tax: #{recipient_card.put_tax(amount)}\n"
      break
    end
  end
end