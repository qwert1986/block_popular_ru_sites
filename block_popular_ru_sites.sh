#!/bin/bash

# Скрипт для блокировки популярных российских сайтов и приложений на уровне сервера

echo "Настраиваем блокировку популярных российских сайтов и приложений..."

# Список популярных российских сайтов и доменов приложений
SITES=(
    # Популярные сайты
    "yandex.ru"
    "ya.ru"
    "ok.ru"
    "vk.com" 
    "mail.ru"
    "rambler.ru"
    "avito.ru"
    "ozon.ru"
    "wildberries.ru"
    "kinopoisk.ru"
    "pikabu.ru"
    "ria.ru"
    "rt.com"
    "gazeta.ru"
    "lenta.ru"
    "rbc.ru"
    "tass.ru"
    "kp.ru"
    "mk.ru"
    "aif.ru"
    "kommersant.ru"
    "vedomosti.ru"
    "habr.com"
    "drive2.ru"
    "banki.ru"
    "auto.ru"
    "cian.ru"
    "drom.ru"
    "2gis.ru"
    "dns-shop.ru"
    "mvideo.ru"
    "eldorado.ru"
    "sberbank.ru"
    "vtb.ru"
    "alfabank.ru"
    "beeline.ru"
    "mts.ru"
    "megafon.ru"
    "tele2.ru"
    
    # Мессенджеры и социальные сети
    "vk.me"
    "vkontakte.ru"
    "odnoklassniki.ru"
    "ok.ru"
    "my.mail.ru"
    "agent.mail.ru"
    "icq.com"
    "icq.net"
    "tamtam.chat"
    
    # Российские мессенджеры
    "vk.com"
    "vkuseraudio.net"
    "vkuserlive.com"
    "userapi.com"
    
    # Яндекс сервисы
    "yandex.net"
    "yandex.com"
    "yastatic.net"
    "yandexcloud.net"
    "auto.yandex.ru"
    "market.yandex.ru"
    "music.yandex.ru"
    "kinopoisk.ru"
    "afisha.yandex.ru"
    "realty.yandex.ru"
    "taxi.yandex.ru"
    "eda.yandex.ru"
    "lavka.yandex.ru"
    "plus.yandex.ru"
    
    # Mail.ru сервисы
    "mail.ru"
    "bk.ru"
    "list.ru"
    "inbox.ru"
    "internet.ru"
    "mail.com"
    
    # Популярные российские приложения
    "sberbank.ru"
    "sber.ru"
    "vtb.ru"
    "tinkoff.ru"
    "alfabank.ru"
    "raiffeisen.ru"
    "gosuslugi.ru"
    "mos.ru"
    
    # Доставка еды и такси
    "yandex.ru"
    "delivery-club.ru"
    "deliveryclub.ru"
    "citymobil.ru"
    "gett.ru"
    "uber.ru"
    
    # Популярные игры
    "wargaming.net"
    "world-of-tanks.ru"
    "worldoftanks.ru"
    "worldofwarships.ru"
    "worldofwarplanes.ru"
    "wot.ru"
    "wows.ru"
    "wowp.ru"
    "gaijin.net"
    "warthunder.ru"
    "warthunder.com"
    "my.games"
    "mail.ru"
    "warface.ru"
    "allods.ru"
    "skyforge.ru"
    "armored-warfare.ru"
    
    # Российские облачные сервисы
    "cloud.mail.ru"
    "disk.yandex.ru"
    "cloud.yandex.ru"
    "sbercloud.ru"
    "mts.ru"
    "beeline.ru"
    "megafon.ru"
    "tele2.ru"
    
    # Стриминговые сервисы
    "kinopoisk.ru"
    "ivi.ru"
    "more.tv"
    "start.ru"
    "wink.ru"
    "okko.tv"
    "premier.one"
    "amediateka.ru"
    
    # Российские поисковики
    "yandex.ru"
    "mail.ru"
    "rambler.ru"
    "nigma.ru"
    "sputnik.ru"
    
    # Государственные сайты
    "kremlin.ru"
    "government.ru"
    "duma.gov.ru"
    "council.gov.ru"
    "ksrf.ru"
    "vsrf.ru"
    "genproc.gov.ru"
    "sledcom.ru"
    "mvd.ru"
    "fsb.ru"
    "svr.gov.ru"
    "fso.gov.ru"
    "rosgvardia.ru"
    "mchs.gov.ru"
    "mil.ru"
    "mid.ru"
    "minjust.gov.ru"
    "minfin.gov.ru"
    "economy.gov.ru"
    "minenergo.gov.ru"
    "minpromtorg.gov.ru"
    "minstroyrf.gov.ru"
    "mintrans.gov.ru"
    "minzdrav.gov.ru"
    "minobr.gov.ru"
    "minobrnauki.gov.ru"
    "minkultrfrf.gov.ru"
    "minvostokrazvitiya.gov.ru"
    "mcx.gov.ru"
    "minprirody.gov.ru"
    "mintrud.gov.ru"
    "minkomsvyaz.ru"
    "roskomnadzor.ru"
    "rkn.gov.ru"
    "fas.gov.ru"
    "cbr.ru"
    "nalog.gov.ru"
    "customs.gov.ru"
    "rosstat.gov.ru"
    "rospotrebnadzor.ru"
    "rostekhnadzor.gov.ru"
    "rosreestr.gov.ru"
    "rosnedra.gov.ru"
    "rospatent.gov.ru"
    "rosstandart.gov.ru"
    "rosavtodor.gov.ru"
    "rosmorrechflot.gov.ru"
    "favt.gov.ru"
    "roszeldor.gov.ru"
    "rosatom.ru"
    "roscosmos.ru"
    "pfr.gov.ru"
    "fss.ru"
    "ffoms.gov.ru"
    "zakupki.gov.ru"
    "gosuslugi.ru"
    
    # Региональные сайты
    "mos.ru"
    "spb.ru"
    "admkrasnodar.ru"
    "novosibirsk.ru"
    "ekaterinburg.ru"
    "nn.ru"
    "samara.ru"
    "omsk-city.ru"
    "kazan.ru"
    "cheladmin.ru"
    "rostov-gorod.ru"
    "ufa-city.ru"
    "perm.ru"
    "volgograd.ru"
    "voronezh-city.ru"
    "krasnoyarsk.ru"
    "saratov.gov.ru"
    "tolyatti.ru"
    "izhevsk.ru"
    "barnaul.org"
    "ulan-ude-eg.ru"
    "irk.ru"
    "yaroslavl.ru"
    "vladivostok.ru"
    "khabarovsk.ru"
    "orenburg.ru"
    "novokuznetsk.ru"
    "ryazan.ru"
    "tyumen.ru"
    "lipetsk.ru"
    "tula.ru"
    "kirov.ru"
    "cheboksary.ru"
    "kursk.ru"
    "magnitogorsk.ru"
    "tver.ru"
    "stavropol.ru"
    "sochi.ru"
    "nizhniy-tagil.ru"
    "arhcity.ru"
    "belgorod.ru"
    "kaluga.ru"
    "bryansk.ru"
    "kurgan.ru"
    "smolensk.ru"
    "orel.ru"
    "vladimir.ru"
    "chita.ru"
)

# Дополнительные IP-диапазоны российских провайдеров и сервисов
IP_RANGES=(
    # Яндекс
    "5.45.192.0/18"
    "5.255.192.0/18"
    "37.9.64.0/18"
    "37.140.128.0/18"
    "77.88.0.0/18"
    "87.250.224.0/19"
    "93.158.128.0/18"
    "95.108.128.0/17"
    "128.140.168.0/21"
    "141.8.136.0/21"
    "178.154.128.0/17"
    "199.21.96.0/22"
    "213.180.192.0/19"
    
    # Mail.ru
    "94.100.176.0/20"
    "95.163.32.0/19"
    "217.69.128.0/20"
    
    # VK.com
    "87.240.128.0/18"
    "95.142.192.0/20"
    "185.32.248.0/22"
    
    # Rostelecom
    "109.254.0.0/16"
    "188.170.0.0/16"
    
    # МТС
    "212.188.0.0/16"
    "217.118.0.0/16"
    
    # Beeline
    "217.107.0.0/16"
    "91.203.0.0/16"
)

# Создаем новую цепочку
sudo iptables -N BLOCK_RU_POPULAR 2>/dev/null || true
sudo iptables -F BLOCK_RU_POPULAR

count=0
ip_count=0

echo "Блокируем домены и получаем их IP-адреса..."

# Получаем IP-адреса сайтов и добавляем в блокировку
for site in "${SITES[@]}"; do
    echo "Обрабатываем $site..."
    
    # Получаем все IP-адреса для сайта
    ips=$(dig +short $site A | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')
    
    for ip in $ips; do
        if [ ! -z "$ip" ]; then
            echo "  Блокируем IP: $ip ($site)"
            sudo iptables -A BLOCK_RU_POPULAR -d $ip -j REJECT --reject-with icmp-net-unreachable
            ((count++))
        fi
    done
    
    # Небольшая пауза чтобы не перегружать DNS
    sleep 0.3
done

echo "Блокируем IP-диапазоны российских провайдеров..."

# Блокируем IP-диапазоны
for range in "${IP_RANGES[@]}"; do
    echo "Блокируем диапазон: $range"
    sudo iptables -A BLOCK_RU_POPULAR -d $range -j REJECT --reject-with icmp-net-unreachable
    ((ip_count++))
done

# Применяем цепочку к исходящему и пересылаемому трафику
sudo iptables -I OUTPUT -j BLOCK_RU_POPULAR
sudo iptables -I FORWARD -j BLOCK_RU_POPULAR

echo ""
echo "============================================"
echo "Блокировка настроена!"
echo "Заблокировано $count IP-адресов популярных российских сайтов и приложений"
echo "Заблокировано $ip_count IP-диапазонов российских провайдеров"
echo "============================================"
echo ""
echo "Заблокированы сервисы:"
echo "• Социальные сети: VK, OK, Mail.ru"
echo "• Мессенджеры: VK, Mail.ru Agent, ICQ"
echo "• Яндекс сервисы: Поиск, Карты, Такси, Еда, Музыка"
echo "• Банковские приложения: Сбербанк, ВТБ, Тинькофф, Альфа"
echo "• Доставка еды: Яндекс.Еда, Delivery Club"
echo "• Стриминг: Кинопоиск, IVI, More.TV, START"
echo "• Игры: World of Tanks, War Thunder, Warface"
echo "• Государственные порталы и сайты"
echo ""
echo "Для просмотра заблокированных правил:"
echo "sudo iptables -L BLOCK_RU_POPULAR -v"
echo ""
echo "Для удаления блокировки:"
echo "sudo iptables -D OUTPUT -j BLOCK_RU_POPULAR"
echo "sudo iptables -D FORWARD -j BLOCK_RU_POPULAR"
echo "sudo iptables -F BLOCK_RU_POPULAR"
echo "sudo iptables -X BLOCK_RU_POPULAR"
