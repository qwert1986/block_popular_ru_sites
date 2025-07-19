# block_popular_ru_sites

0. Delete all existing rules and make rm block_popular_ru_sites.sh

1. wget https://raw.githubusercontent.com/qwert1986/block_popular_ru_sites/main/block_popular_ru_sites.sh

2. chmod +x block_popular_ru_sites.sh

3. sudo ./block_popular_ru_sites.sh

4. sudo apt install iptables-persistent (optional)

5. sudo netfilter-persistent save

   

For rollback:

1. sudo iptables -D OUTPUT -j BLOCK_ALL_RUSSIAN 2>/dev/null || true
  
2. sudo iptables -D FORWARD -j BLOCK_ALL_RUSSIAN 2>/dev/null || true

3. sudo ip6tables -F BLOCK_ALL_RUSSIAN 2>/dev/null || true
 
4. sudo ip6tables -X BLOCK_ALL_RUSSIAN 2>/dev/null || true

5. sudo apt install iptables-persistent (optional)

6. sudo netfilter-persistent save
