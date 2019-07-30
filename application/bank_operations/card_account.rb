require_relative '../../application/cards/card_usual'
require_relative '../../application/cards/card_capitalist'
require_relative '../../application/cards/card_virtual'
require_relative '../helpers/messages'
require_relative '../../application/helpers/file_manager'
require_relative '../validation'

module CardOperations
  include Messages
  include FileManager
  include Validation

  def create_card
    loop do
      create_card_message
      cardtype = gets.chomp
      card = generate_card(cardtype)
      return puts "Wrong card type. Try again!\n" if card.nil?

      cards = @current_account.card << card
      @current_account.card = cards # important!!!
      update_accounts(@current_account)
      break
    end
  end

  def destroy_card
    loop do
      puts 'If you want to delete:'
      break unless show_cards_for_operations

      exit_message
      choice = gets.chomp
      break if choice == 'exit'

      if answer_validation(choice)
        puts "Are you sure you want to delete #{@current_account.card[choice.to_i - 1].number}?[y/n]"
        confirmation = gets.chomp
        return unless confirmation == 'y'

        @current_account.card.delete_at(choice.to_i - 1)
        update_accounts(@current_account)
        break
      else
        puts "You entered wrong number!\n"
      end
    end
  end

  def show_cards
    if cards
      @current_account.card.each do |card|
        puts "- #{card.number}, #{card.type}"
      end
    else
      puts "There is no active cards!\n"
    end
  end

  def show_cards_for_operations
    if cards
      @current_account.card.each_with_index do |card, index|
        puts "- #{card.number}, #{card.type}, press #{index + 1}"
      end
    else
      puts "There is no active cards!\n"
      false
    end
  end

  def update_accounts(updated_account)
    new_accounts = accounts.map do |account|
      account.login == updated_account.login ? updated_account : account
    end
    write_to_file(new_accounts)
  end

  def update_balance(card)
    accounts.each do |account|
      account.card.each do |account_card|
        account_card.balance = card.balance if account_card.number == card.number
      end
    end
  end

  def get_account_by_card(card)
    accounts.each do |account|
      account.card.each do |account_card|
        return account if account_card.number == card.number
      end
    end
  end

  def cards
    @current_account.card.any?
  end

  def generate_card(enter)
    case enter
    when 'usual'      then CardUsual.new
    when 'capitalist' then CardCapitalist.new
    when 'virtual'    then CardVirtual.new
    end
  end
end