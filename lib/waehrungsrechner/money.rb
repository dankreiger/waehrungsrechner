require 'httparty'

class Money
  attr_reader :amount, :base_currency, :rates

  def initialize amount, base_currency
    raise ArgumentError, " `#{base_currency}` is invalid (currency symbol must be a 3 character string)`#{base_currency}` is invalid." unless valid_currency? base_currency
    begin
      @rate_info = HTTParty.get "http://api.fixer.io/latest?base=#{base_currency}"
      raise ArgumentError, "`#{base_currency}` is an invalid currency symbol." if @rate_info.include? 'error'
    rescue Exception => e
      puts "Something went wrong. Please make sure are connected to the internet."
      puts e.inspect
    end

    @amount = amount
    @base_currency = base_currency
  end

  def inspect
    "#{'%.2f' % amount} #{base_currency.upcase}"
  end

  def convert_to transfer_currency
    raise ArgumentError, "`#{transfer_currency}` must be a 3 character string" unless transfer_currency.is_a?(String) && transfer_currency.length == 3
    raise ArgumentError, "`#{transfer_currency}` is either an invalid currency symbol, or it is not currently supported." unless (rates = @rate_info['rates']) && rates.keys.include?(transfer_currency)

    amount * rates[transfer_currency]
  end

  private

  def valid_currency? currency
    currency.is_a?(String) && currency.length == 3
  end
end
