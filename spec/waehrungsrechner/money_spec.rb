require "spec_helper"
require "waehrungsrechner"

describe Money do
  let(:amount)   { 50 }
  let(:currency) { 'EUR' }
  let(:money)    { Money.new(amount, currency) }
  let(:rates)    { HTTParty.get("http://api.fixer.io/latest?base=#{currency}")['rates'] }

  it "returns the inputted amount" do
    expect(money.amount).to eq 50
  end

  it "returns the inputted currency" do
    expect(money.base_currency).to eq 'EUR'
  end

  it "returns a readable string with the amount and currency" do
    expect(money.inspect).to eq '50.00 EUR'
  end

  it "converts the given amount and currency to a newly inputted currency" do
    expect(money.convert_to('USD')).to eq amount * rates['USD']
  end
end
