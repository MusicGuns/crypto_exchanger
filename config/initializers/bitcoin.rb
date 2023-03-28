BLOCKSTREAM_API = 'https://blockstream.info/testnet/api/'
KEY = Bitcoin::Key.from_base58(Rails.application.credentials.private_key)
