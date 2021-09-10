User.create!([
  {email: 'admin@example.com', password: 'password', role: 'admin', firstname: 'admin', lastname: 'admin', username: 'admin'},
  {email: 'buyer@example.com', password: 'password', role: 'buyer', firstname: 'buyer', lastname: 'buyer', username: 'buyer', balance: 99_999_999}])
User.create!(email: 'broker@example.com', password: 'password', role: 'broker', firstname: 'broker', lastname: 'broker', username: 'broker').update_column(:role, 'broker')
User.create!(email: 'broker2@example.com', password: 'password', role: 'broker', firstname: 'broky', lastname: 'broky', username: 'broker2').update_column(:role, 'broker')
User.create!(email: 'stockup_brokers@stockup-trading.com', password: 'password', role: 'broker', firstname: 'StockUp', lastname: 'Official', username: 'StockUpBrokers')
             .update_column(:role, 'broker')

client = IEX::Api::Client.new
Money.rounding_mode = BigDecimal::ROUND_HALF_UP # Money Gem conflict

# Scraped from https://www.nasdaq.com/market-activity/quotes/nasdaq-ndx-index as of Sep 7, 2021

nasdaq_100 = [
  "AAPL", "ADBE", "ADI", "ADP", "ADSK", "AEP", "ALGN", "AMAT", "AMD", "AMGN", "AMZN", "ANSS", "ASML", "ATVI", "AVGO", "BIDU", "BIIB", "BKNG",
  "CDNS", "CDW", "CERN", "CHKP", "CHTR", "CMCSA", "COST", "CPRT", "CRWD", "CSCO", "CSX", "CTAS", "CTSH", "DLTR", "DOCU", "DXCM", "EA", "EBAY",
  "EXC", "FAST", "FB", "FISV", "FOX", "FOXA", "GILD", "GOOG", "GOOGL", "HON", "IDXX", "ILMN", "INCY", "INTC", "INTU", "ISRG", "JD", "KDP", "KHC",
  "KLAC", "LRCX", "LULU", "MAR", "MCHP", "MDLZ", "MELI", "MNST", "MRNA", "MRVL", "MSFT", "MTCH", "MU", "NFLX", "NTES", "NVDA", "NXPI", "OKTA", "ORLY",
  "PAYX", "PCAR", "PDD", "PEP", "PTON", "PYPL", "QCOM", "REGN", "ROST", "SBUX", "SGEN", "SIRI", "SNPS", "SPLK", "SWKS", "TCOM", "TEAM", "TMUS", "TSLA",
  "TXN", "VRSK", "VRSN", "VRTX", "WBA", "WDAY", "XEL", "XLNX", "ZM"
]

# Create Stocks
# Stock real-time prices are not included in the free version of IEX gem
@broker = User.find_by(username: 'StockUpBrokers')
nasdaq_100.each do |symbol|
    historical_prices = client.historical_prices(symbol, {range: 'date', date: Date.yesterday, chartByDay: 'true'})
    stock = Stock.create!(ticker: symbol,
                          company_name: client.company(symbol).company_name,
                          last_transaction_price: historical_prices.first.close,
                          quantity: Faker::Number.within(range: 100..100_000),
                          logo: client.logo(symbol).url
                        )
    UserStock.create!(user_id: @broker.id, stock_id: stock.id)
    Order.create!(transaction_type: 'sell', user_id: @broker.id, stock_id: stock.id, price: stock.last_transaction_price, quantity: stock.quantity)
end


# Create Buy Orders
@buyer = User.find_by(username: 'buyer')
@stock = Stock.first
# Destroys Sell Order and Creates Pending Buy Order
@buyer.orders.create(stock: @stock, quantity: @stock.quantity, price: @stock.last_transaction_price, transaction_type: 'buy')
@buyer.orders.create(stock: @stock, quantity: 50, price: (@stock.last_transaction_price * 0.97), transaction_type: 'buy')
User.find_by(username: 'broker2').orders.create(stock: @stock, quantity: 10, price: (@stock.last_transaction_price * 0.95), transaction_type: 'buy')
User.find_by(username: 'broker').orders.create(stock: @stock, quantity: 10, price: (@stock.last_transaction_price * 0.90), transaction_type: 'buy')
# Sell Order is partially fulfilled
@stock2 = Stock.find(2)
@buyer.orders.create(stock: @stock2, quantity: (@stock2.quantity * 0.1).floor, price: @stock2.last_transaction_price, transaction_type: 'buy')
