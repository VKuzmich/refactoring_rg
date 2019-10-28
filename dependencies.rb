# frozen_string_literal: true

require 'yaml'
require 'pry'
require 'i18n'

require_relative 'config/i18n'

require_relative 'application/helpers/database'
require_relative 'application/cards/card'
require_relative 'application/cards/card_usual'
require_relative 'application/cards/card_capitalist'
require_relative 'application/cards/card_virtual'

require_relative 'application/validators/login_validator'
require_relative 'application/validators/login_unique_validator'
require_relative 'application/validators/name_validator'
require_relative 'application/validators/name_validator'
require_relative 'application/validators/age_validator'
require_relative 'application/validators/password_validator'

require_relative 'application/helpers/user_info'
require_relative 'application/account'

require_relative 'application/console/console_helper'
require_relative 'application/console/cards_console'
require_relative 'application/console/console'
