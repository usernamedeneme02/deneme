echo "██╗  ██╗██████╗ ██╗██████╗ ████████╗ ██████╗     ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗   ██╗";
echo "██║ ██╔╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔═══██╗    ██║ ██╔╝██║   ██║██╔══██╗██╔══██╗██║   ██║";
echo "█████╔╝ ██████╔╝██║██████╔╝   ██║   ██║   ██║    █████╔╝ ██║   ██║██████╔╝██║  ██║██║   ██║";
echo "██╔═██╗ ██╔══██╗██║██╔═══╝    ██║   ██║   ██║    ██╔═██╗ ██║   ██║██╔══██╗██║  ██║██║   ██║";
echo "██║  ██╗██║  ██║██║██║        ██║   ╚██████╔╝    ██║  ██╗╚██████╔╝██║  ██║██████╔╝╚██████╔╝";
echo "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝    ╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝ ";
echo "                                                                                           ";



sleep 1


# Güncellemeler 
sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# Go setup 

if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi



# MONİKER AD BELİRLEME
read -p "Moniker Adinizi Giriniz : " NODENAME
echo 'export NODENAME='\"${NODENAME}\" >> $HOME/.bash_profile

# REPO YÜKLE

cd $HOME
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v0.15.0
make install


#NODE ÇALIŞTIRMA

nibid config keyring-backend test
nibid config chain-id nibiru-testnet-1
nibid init $NODENAME --chain-id nibiru-testnet-1
nibid config node tcp://localhost:26657




# Genesis yükleme

curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > genesis.json
cp genesis.json $HOME/.nibid/config/genesis.json




# Pers ayarlama

PEERS="335c5799da4a2e41c980bd3597f9f220c593057a@137.184.224.82:26656,d5ed940d493e6d462518e88f6689ff6a17d92b62@137.184.124.241:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml

sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025unibi"/g' $HOME/.nibid/config/app.toml

#Blok süresi ayarlama
CONFIG_TOML="$HOME/.nibid/config/config.toml"
 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML

 
 
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml



nibid tendermint unsafe-reset-all --home $HOME/.nibid



sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibid
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start --home $HOME/.nibid
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF



# Node başlat

sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid && sudo journalctl -u nibid -f -o cat
