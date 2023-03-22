class RatesController < ApplicationController
  def rate
    rate = Net::HTTP.get(URI('https://blockchain.info/tobtc?currency=USD&value=1')).to_f
    render json: rate
  end
end
