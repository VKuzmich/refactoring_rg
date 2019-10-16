# frozen_string_literal: true

require 'yaml'

class Account
  attr_accessor :name, :login, :password, :age, :card, :file_path, :errors, :current_account

  PATH = 'accounts.yml'

  def initialize
    @card = []
    @errors = []
    @file_path = PATH
    @name = :name
    @age = :age
    @login = :login
    @password = :password
  end

  def add_card(card)
    @card << card
  end

  def delete_card(index)
    @card.delete_at(index)
  end
end
