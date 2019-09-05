
module UI
  COMMANDS = {
      create: 'create',
      load: 'load',
      show_cards: 'SC',
      create_card: 'CC',
      destroy_card: 'DC',
      put_money: 'PM',
      withdraw_money: 'WM',
      destroy_account: 'DA'
  }.freeze



  def menu(name)
    puts I18n.t(:MAIN_MENU, name: name)
    gets.chomp
  end

  def wrong_command
    puts I18n.t('ERROR.wrong_command')
  end


  def show_errors
    @errors.each { |error| puts error }
    @errors = []
  end
end