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

PEERS="751f76832ae3aefe9373ee697f4699c4bd0acafc@161.97.136.141:26656,93137cb574b5d6bd6fdb60e6c8164a08c1516081@209.126.8.192:26656,968472e8769e0470fadad79febe51637dd208445@65.108.6.45:60656,573946fee0377eb9448bfb7cb731ffbb41b2b078@38.242.214.172:2486,2e90413e61ff3b7f1098c7cd46a283142af133ce@80.65.211.115:26656,ff597c3eea5fe832825586cce4ed00cb7798d4b5@65.109.53.53:26656,145c04540ea9fad36d97a6c37b66d134e19a5450@38.242.152.235:26656,51625ddeba19faec101fe10423315856f82257ca@51.222.155.224:26656,2b93c4402a26adc73e043d9a35f3cedd4aea311b@149.102.129.200:26656,eb65c95ea745d1cb5f66e2fda5d5e1029f4dc43d@5.161.43.109:26656,f30138f9d0c986b511ea476eb199fead17a62ae4@45.67.217.120:46656,5d46e8a12044703e3a711462261652b0164a3ca6@194.233.84.166:39656,ae357e14309640ca33cde597b37f0a91e63a32bd@144.76.90.130:36656,358a862e6851d8afe4efb7e0a9223b770a745eb0@34.142.140.178:39656,7445531c80f47f5469d2244d59276fa4f569515e@161.97.105.100:26656,75df3cedd70ef5db343278eb67e94a41949358b1@45.67.217.225:46656,88cfcca95e534bf32092a8d70cff646cf46d8202@154.26.132.182:26656,d8b4d4ddef3e99d2a66dbc25568ce6e91c7d5568@43.156.112.23:26656,6794490764f688fde88befee0340eaea022cd8d1@161.97.105.44:26656,659030eeffba5cf38c7d5f66bd46447d2048d443@62.171.171.178:26656,3997242f9646ca642932852b7577ddb9976e0396@5.199.130.53:26656,213d1398817da527b4c3c05f4fe64302382d6733@146.190.99.66:39656,001f41373472f1a04512e75185d2de68a1f390bd@65.108.105.37:28656,01c942713a9b910c4990210459c9360c7e8307bf@161.97.105.134:26656,920a63eac8ddc9ad63b5d5bdb1ff55f0f3dec913@65.21.242.148:26656,4372060d7b7268818944a3697fbad1897152ce0d@5.161.99.245:36656,d458fc63d2c49888af3b91e5d13279dc3c96fa92@185.245.183.232:46656,070d8f6373f57092d53b9a5e0062228074469498@65.109.8.96:26656,9288e8ab4f01383ac1864ddcb7f9eccc4c2e8810@83.171.248.175:39656,7bbe4afc59fbfff5e6c3189c8ef73a1c6ac3f067@80.82.215.23:26656,9007f52d9f46c581bf4a0fc6f4a108699caa4676@135.181.83.112:39656,d4cc19cf98ff84863916445a33a6301e1bf32866@80.82.215.211:26656,6ed3b1b345e99bca60f04de930d6d11792923713@95.216.159.99:39656,a0dd9905a3511c174c504b1ea953c7e5f1dbc9ab@65.108.217.146:39656,3b8e8283c3778af3c0e29e406f4aee5eb608e64d@62.171.172.51:26656,1b786fbb3a0db6f2ec99fdd2424d4aacddc10ed4@77.75.230.201:26656,66363f55c128ce60bb4c5ebfbc070ec464bcd532@80.82.215.220:26656,fa4c53154dcc202619aa4b5cb156570f45896f45@5.161.56.143:26656,c687fa90a86bd34161fa67e7945448cac4a18844@46.228.205.196:26656,dee5a6d44b302445d5cf521d2b9c3fd9a3ae21cb@161.97.70.202:26656,f8038bd699a307c75d9e2a5d57518ff05f455836@142.132.182.1:36656,34b70090fcc8e1ebf6be10be6e314e8d66931371@185.239.208.90:26656,600ac00790f11f7c0803dceb42c55a8a8f35dd99@62.141.44.46:26656,65436a8aba0cd3809a79c3c4c5a53e70eb6d6ba4@128.199.219.116:39656,f880e569c033251cc90d015d77e25d66da51ed77@185.215.166.85:39656,e2b8b9f3106d669fe6f3b49e0eee0c5de818917e@213.239.217.52:32656,95989bb86344422e5b67c059b474ee432c387f69@38.242.217.12:26656,1038f545b6495d29f1962fd72ba464d2277b85bb@194.5.152.252:26656,9cd4ae9fc3751432fee22593894655ecacecf9e9@109.111.160.171:36656,9b6b62540afaabd7b75b80e641bf3b12dfd65bed@185.135.137.237:26656
"

sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml



#Blok süresi ayarlama

 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $HOME/.nibid/config/config.toml
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $HOME/.nibid/config/config.toml
 
 
 



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
