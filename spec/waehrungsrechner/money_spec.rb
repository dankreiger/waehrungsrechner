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

  it "converts the given amount and currency to a newly inputted currency" do
    expect(money_euro.convert_to('USD').inspect).to eq Money.new(50 * rates['USD'], 'USD').inspect
  end

  it "adds two money objects together" do
    expect(money_euro + money_euro2).to eq (money_euro.amount + money_euro2.amount), 'EUR'
    $stdin = StringIO.new("1")
    expect(money_euro + money_usd).to eq (money_euro.amount + money_usd.convert_to('EUR').amount)
    $stdin = StringIO.new("2")
    expect(money_euro + money_usd).to eq (money_euro.convert_to('USD').amount + money_usd.amount)
  end


  def fetch_rates(base_currency)
    HTTParty.get("http://api.fixer.io/latest?base=#{base_currency}")['rates']
  end
end
