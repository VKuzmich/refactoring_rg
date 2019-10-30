# frozen_string_literal: true

require_relative '../../dependencies'

class AgeValidator
  attr_accessor :errors, :age

  def initialize(age)
    @errors = []
    @age = age
  end

  def valid?
    @errors << I18n.t(:age_between_23_and_90) unless (Account::VALID_RANGE[:age]).cover?(@age)
    @errors.empty?
  end
end
