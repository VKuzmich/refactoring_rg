# frozen_string_literal: true

require 'yaml'

class Account
  attr_accessor :name, :login, :password, :age, :card, :file_path, :errors, :current_account

  PATH = 'accounts.yml'

  def initialize
    @card = []
    @errors = []
    @file_path = PATH
  end

  def access?(credentials)
    @login == credentials[:login] && @password == credentials[:password]
  end


  def equal?(other)
    @login == other.login
  end

  def add_card(card)
    @card << card
  end

  def delete_card(index)
    @card.delete_at(index)
  end
end
