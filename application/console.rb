# frozen_string_literal: true

module Console
  def console
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - enter `create`'
    puts '- If you want to load account - enter `load`'
    puts '- If you want to exit - enter `exit`'

    choose = gets.chomp

    case choose
    when 'create' then create
    when 'load'   then load
    else exit
    end
  end


end