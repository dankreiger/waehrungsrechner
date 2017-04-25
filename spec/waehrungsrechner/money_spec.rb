require "spec_helper"
require "stringio"

describe Money do
  let(:money_euro)   { Money.new(50, 'EUR') }
  let(:money_euro2)  { Money.new(60, 'EUR') }
  let(:money_usd)    { Money.new(45, 'USD') }
  let(:rates)        { fetch_rates('EUR') }

  it "returns an inputted amount" do
    expect(money_euro.amount).to eq 50
  end

  it "does not accept non-numericals for the amount" do
    expect{Money.new('50 hi there', 'EUR')}.to raise_error ArgumentError, 'Amount must be a number'
  end

  it "returns the inputted currency" do
    expect(money_euro.base_currency).to eq 'EUR'
  end

  it "returns a readable string with the amount and currency" do
    expect(money_euro.inspect).to eq('50.00 EUR')
  end

  it "converts the given amount and currency to a newly inputted currency and returns the appropriate money object" do
    expect(money_euro.convert_to('USD').inspect).to eq Money.new(50 * rates['USD'], 'USD').inspect
    expect(money_euro.convert_to('USD').amount).to eq Money.new(50 * rates['USD'], 'USD').amount
    expect(money_euro.convert_to('USD').base_currency).to eq Money.new(50 * rates['USD'], 'USD').base_currency
  end

  it "adds two money objects together" do
    expect((money_euro + money_euro2).inspect).to eq Money.new(110, 'EUR').inspect
    # show addition in EUR
    $stdin = StringIO.new("EUR")
    expect((money_euro + money_usd).inspect).to eq Money.new((money_euro.amount + money_usd.convert_to('EUR').amount), 'EUR').inspect
    # show addition in USD
    $stdin = StringIO.new("USD")
    expect((money_euro + money_usd).inspect).to eq Money.new((money_euro.convert_to('USD').amount + money_usd.amount), 'USD').inspect
  end


  def fetch_rates(base_currency)
    HTTParty.get("http://api.fixer.io/latest?base=#{base_currency}")['rates']
  end
end
