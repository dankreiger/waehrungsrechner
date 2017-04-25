require 'httparty'

class Money
  attr_reader :amount, :base_currency, :rates

  def initialize amount, base_currency
    raise ArgumentError, "Amount must be a number" unless amount.is_a? Numeric
    raise ArgumentError, " `#{base_currency}` is invalid (currency symbol must be a 3 character string)`#{base_currency}` is invalid." unless valid_currency? base_currency
    begin
      @rate_info = HTTParty.get "http://api.fixer.io/latest?base=#{base_currency}"
      raise ArgumentError, "`#{base_currency}` is an invalid currency symbol." if @rate_info.include? 'error'
    rescue Exception => e
      puts "Something went wrong. Please make sure are connected to the internet."
      puts e.inspect
    end
    base_currency.upcase!
    @amount = amount
    @base_currency = base_currency
  end

  def inspect
    "#{('%.2f' % amount)} #{base_currency.upcase}"
  end

  def convert_to transfer_currency
    raise ArgumentError, "`#{transfer_currency}` must be a 3 character string" unless transfer_currency.is_a?(String) && transfer_currency.length == 3
    raise ArgumentError, "`#{transfer_currency}` is either an invalid currency symbol, or it is not currently supported." unless (rates = @rate_info['rates']) && rates.keys.include?(transfer_currency)
    Money.new(amount * rates[transfer_currency], transfer_currency)
  end

  def conversion_amount transfer_currency
    convert_to(transfer_currency).amount
  end

  # adding money objects together
  def +(other)
    if base_currency == other.base_currency
      Money.new(amount + other.amount, base_currency)
    else
      # maybe ask the user?
      puts "Which currency would you like to see the total in?\n1.#{base_currency}\n2.#{other.base_currency}"
      answer = gets.chomp
      case answer.upcase
      # calculate the total in the base currency
      when '1', "#{base_currency}"
        Money.new(amount + other.conversion_amount(base_currency), base_currency)
        # calculate the total in the transfer currency
      when '2', "#{other.base_currency}"
        Money.new(self.conversion_amount(other.base_currency) + other.amount, other.base_currency)
      end
    end
  end

  private

  def valid_currency? currency
    currency.is_a?(String) && currency.length == 3
  end
end
