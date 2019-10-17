# frozen_string_literal: true

require 'yaml'
# require_relative 'cards/card_usual'
# require_relative 'cards/card_capitalist'
# require_relative 'cards/card_virtual'
# require_relative 'bank_operations/with_account'
# require_relative 'validation'
# require_relative 'helpers/ui'
require_relative 'dependencies'

class Account
  attr_accessor :name, :login, :password, :age, :card, :file_path, :errors, :current_account

  include Database
  include Validation
  include UI

  PATH = 'accounts.yml'

  def initialize
    @card = []
    @errors = []
    @file_path = PATH
  end

  def card_present(card)
    @account.current_account.card.include? card
  end

  def create_new_card(type)
    case type
    when I18n.t('Usual')
      CardUsual.new
    when I18n.t('Capitalist')
      CardCapitalist.new
    when I18n.t('Virtual')
      CardVirtual.new
    end
  end

  def destroy
    write_to_file(load_db.reject { |account| account.login == @login })
  end

  def update_card; end
end
