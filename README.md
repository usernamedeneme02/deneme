source <(curl -s https://raw.githubusercontent.com/usernamedeneme02/deneme/main/denelev.sh)

nibid keys add name  # name yerine bir cüzdan ismi yazın


#moniker adimizi ve wallet adimizi ekliyoruz buraya


nibid tx staking create-validator \
--amount=1000000unibi \
--pubkey=$(nibid tendermint show-validator) \
--moniker="$NIBIRU_NODENAME" \
--chain-id=nibiru-testnet-1 \
--commission-rate="0.1" \
--commission-max-rate="0.10" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000" \
--fees=10000unibi \
--from=wallet \
-y
