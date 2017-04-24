# class RatesApi
#   def self.[](base_currency)
#     self.new(base_currency: base_currency)
#   end
#
#   attr_reader :base_currency
#
#   def initialize base_currency:
#     begin
#       rate_info = HTTParty.get "http://api.fixer.io/latest?base=#{base_currency}"
#       raise ArgumentError, "`#{base_currency}` is an invalid currency symbol." if rate_info.include? 'error'
#       raise ArgumentError, "`#{base_currency}` is currently unsupported." unless rate_info['rates'].keys include? base_currency
#     rescue SocketError => se
#       puts "Something went wrong. Please make sure are connected to the internet."
#       puts se.inspect
#     end
#
#     @base_currency = rate_info['base']
#     @date          = rate_info['date']
#     @rates         = rate_info['rates']
#     freeze
#   end
# end
