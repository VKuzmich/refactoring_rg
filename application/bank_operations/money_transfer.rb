# frozen_string_literal: true

require_relative 'card_processes'
require_relative '../helpers/messages'
require_relative '../validation'
require_relative '../helpers/main_menu'

module MoneyTransfer
  include Messages
  include CardProcesses
  include Validation
  include MainMenu

  def withdraw_money
    current_card = choose_card
    until current_card.nil?
      amount = amount_input.to_i
      break if amount.zero?

      current_card.balance = current_card.balance - amount - current_card.withdraw_tax(amount)
      return insufficient_funds unless current_card.balance.positive?

      update_accounts(@account.current_account)
      withdraw_money_msg(amount, current_card)
      break
    end
  end

  def put_money
    current_card = choose_card
    until current_card.nil?
      amount = amount_input.to_i
      break if amount.zero?

      return high_tax unless current_card.put_tax(amount) < amount

      current_card.balance = current_card.balance + amount - current_card.put_tax(amount)
      update_accounts(@account.current_account)
      put_money_msg(amount, current_card)
      break
    end
  end

  def send_money
    sender_card = choose_card
    recipient_card = choose_recipient_card

    until sender_card.nil? || recipient_card.nil?
      amount = amount_input.to_i
      break if amount.zero?

      sender_card.balance = sender_card.balance - amount - sender_card.sender_tax(amount)
      recipient_card.balance = recipient_card.balance + amount - recipient_card.put_tax(amount)

      return insufficient_funds unless sender_card.balance.positive? ||
          recipient_card.put_tax(amount) < amount

      if card_present(recipient_card)
        update_account_by_card(recipient_card, sender_card)
      else
        update_account_by_card(recipient_card)
        update_account_by_card(sender_card)
      end
      send_money_sender_msg(amount, sender_card)
      send_money_recipient_msg(amount, recipient_card)
      break
    end
  end
end
