require 'net/http'

class Transaction < ApplicationRecord
  before_validation :set_get_btc

  validates :send_usdt, presence: true, numericality: { less_than_or_equal_to: 30 }

  validate :less_than_or_equal_get_btc?
  validate :correct_rate?

  validates :address, presence: true
  validate :address_exists?

  validates :email, presence: true, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/

  def generate_transaction
    utxo = JSON.parse(Net::HTTP.get(URI("#{BLOCKSTREAM_API}address/#{KEY.addr}/utxo")))
               .map! do |tx|
      { hash: tx['txid'], index: tx['vout'] }
    end

    utxo.map! do |tx|
      raw = Net::HTTP.get(URI("#{BLOCKSTREAM_API}tx/#{tx[:hash]}/raw"))

      { hash: Bitcoin::Protocol::Tx.new(raw), index: tx[:index] }
    end

    new_tx = build_tx do |t|
      utxo.each do |tx_info|
        t.input do |i|
          i.prev_out tx_info[:hash]
          i.prev_out_index tx_info[:index]
          i.signature_key KEY
        end
      end

      t.output do |o|
        o.value (get_btc * 0.97) * 100_000_000
        o.script { |s| s.recipient address }
      end

      t.output do |o|
        o.value (balance - get_btc * 0.97 - 0.000006) * 100_000_000
        o.script { |s| s.recipient KEY.addr }
      end
    end
    self.txid = new_tx.hash
    Net::HTTP.post(URI("#{BLOCKSTREAM_API}tx"), new_tx.to_payload.bth)
  end

  private

  def set_get_btc
    self.get_btc = rate * send_usdt
  end

  def correct_rate?
    return if rate.to_s == Net::HTTP.get(URI('https://blockchain.info/tobtc?currency=USD&value=1'))

    errors.add(:get_btc, 'Exchange rate has changed')
  end

  def less_than_or_equal_get_btc?
    return if rate * 30 > get_btc.to_f - 0.000006

    errors.add(:get_btc, 'Number of bitcoins exceeds 30 USDt')
  end

  def address_exists?
    return unless Net::HTTP.get(URI("#{BLOCKSTREAM_API}address/#{KEY.addr}")) == 'Invalid Bitcoin address'

    errors.add(:address, 'Incorrect address')
  end

  def balance
    JSON.parse(Net::HTTP.get(URI("#{BLOCKSTREAM_API}address/#{KEY.addr}/utxo")))
        .reduce(0) { |sum, tx| sum + tx['value'] }
        .fdiv(100_000_000)
  end
end
