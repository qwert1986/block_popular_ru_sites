# block_popular_ru_sites
0. If rules exist
sudo iptables -D OUTPUT -j BLOCK_RU_POPULAR
sudo iptables -D FORWARD -j BLOCK_RU_POPULAR
sudo iptables -F BLOCK_RU_POPULAR
sudo iptables -X BLOCK_RU_POPULAR

1. wget https://raw.githubusercontent.com/qwert1986/block_popular_ru_sites/main/block_popular_ru_sites.sh

2. chmod +x block_popular_ru_sites.sh

3. sudo ./block_popular_ru_sites.sh

4. sudo apt install iptables-persistent (optional)

5. sudo netfilter-persistent save
