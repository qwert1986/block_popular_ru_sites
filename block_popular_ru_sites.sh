#!/bin/bash

# === ПОДГОТОВКА: удаление старой цепочки и подключений ===
echo "Удаляем старую цепочку BLOCK_ALL_RUSSIAN и подключения..."

while sudo iptables -D OUTPUT -j BLOCK_ALL_RUSSIAN 2>/dev/null; do :; done
while sudo iptables -D FORWARD -j BLOCK_ALL_RUSSIAN 2>/dev/null; do :; done

sudo iptables -F BLOCK_ALL_RUSSIAN 2>/dev/null || true
sudo iptables -X BLOCK_ALL_RUSSIAN 2>/dev/null || true
sudo ip6tables -F BLOCK_ALL_RUSSIAN 2>/dev/null || true
sudo ip6tables -X BLOCK_ALL_RUSSIAN 2>/dev/null || true

echo "Настраиваем полную блокировку всех популярных российских приложений..."

# МАКСИМАЛЬНО ПОЛНЫЙ список российских сервисов и приложений
ALL_RUSSIAN_DOMAINS=(
    # === СОЦИАЛЬНЫЕ СЕТИ И МЕССЕНДЖЕРЫ ===
    "vk.com" "vkontakte.ru" "vk.me" "userapi.com" "vkuservideo.net" "vkuseraudio.net" "vkuserlive.com"
    "ok.ru" "odnoklassniki.ru" "mycdn.me" "ok-cdn.com"
    "agent.mail.ru" "icq.com" "icq.net" "icq.im"
    "tamtam.chat" "tamtam.me"

    # === ЯНДЕКС ЭКОСИСТЕМА ===
    "yandex.ru" "yandex.com" "yandex.net" "ya.ru" "yastatic.net" "yandex.st"
    "market.yandex.ru" "beru.ru" "pokupki.market.yandex.ru"
    "music.yandex.ru" "radio.yandex.ru" 
    "kinopoisk.ru" "hd.kinopoisk.ru" "api.kinopoisk.dev"
    "afisha.yandex.ru" "concert.yandex.ru"
    "realty.yandex.ru" "arenda.yandex.ru"
    "taxi.yandex.ru" "taxi-routeinfo.taxi.yandex.net" "surge-notify.taxi.yandex.net"
    "eda.yandex.ru" "eda-api.yandex.ru"
    "lavka.yandex.ru" "express.yandex.ru"
    "travel.yandex.ru" "rasp.yandex.ru" "trains.yandex.ru" "avia.yandex.ru"
    "auto.yandex.ru" "autoru.yandex.ru"
    "maps.yandex.ru" "api-maps.yandex.ru" "suggest-maps.yandex.ru"
    "navigator.yandex.ru" "mobile-maps.yandex.ru"
    "translate.yandex.ru" "dictionary.yandex.ru"
    "weather.yandex.ru" "pogoda.yandex.ru"
    "news.yandex.ru" "yandex.ru/news"
    "disk.yandex.ru" "disk.yandex.com" "downloader.disk.yandex.ru"
    "cloud.yandex.ru" "cloud.yandex.com" "storage.yandexcloud.net"
    "connect.yandex.ru" "360.yandex.ru" "mail.yandex.ru"
    "passport.yandex.ru" "oauth.yandex.ru" "login.yandex.ru"
    "metrika.yandex.ru" "mc.yandex.ru" "webvisor.yandex.ru"
    "direct.yandex.ru" "partner.yandex.ru" "awaps.yandex.net"
    "zen.yandex.ru" "dzen.ru"
    "alice.yandex.ru" "dialogs.yandex.ru" "quasar.yandex.ru"
    "practicum.yandex.ru" "lyceum.yandex.ru"
    "geocoder-maps.yandex.ru" "suggest-maps.yandex.ru"
    "plus.yandex.ru" "cashback.yandex.ru"
    "wordstat.yandex.ru" "webmaster.yandex.ru"
    "browser.yandex.ru" "mobile.yandex.ru"
    
    # === MAIL.RU ГРУППА ===
    "mail.ru" "e.mail.ru" "m.mail.ru" "touch.mail.ru"
    "my.mail.ru" "o2.mail.ru" "r.mail.ru" "go.mail.ru"
    "cloud.mail.ru" "disk.mail.ru" "files.mail.ru"
    "auto.mail.ru" "lady.mail.ru" "health.mail.ru"
    "news.mail.ru" "pogoda.mail.ru" "tv.mail.ru"
    "amor.mail.ru" "dating.mail.ru" "flirt.mail.ru"
    "games.mail.ru" "my.games" "lootdog.io"
    "youla.ru" "youla.io"
    "delivery-club.ru" "deliveryclub.ru"
    "citymobil.ru" "city-mobil.ru"
    "sputnik.ru" "top.mail.ru" "list.mail.ru"
    "bk.ru" "inbox.ru" "internet.ru"
    
    # === БАНКОВСКИЕ ПРИЛОЖЕНИЯ ===
    # Сбербанк
    "sberbank.ru" "sber.ru" "sbrf.ru" "online.sberbank.ru" "mobile.sberbank.ru"
    "api.sberbank.ru" "node1.sberbank.ru" "node2.sberbank.ru" "node3.sberbank.ru"
    "id.sber.ru" "auth.sber.ru" "login.sber.ru" "secure.sber.ru" "cabinet.sber.ru"
    "push.sber.ru" "notification.sber.ru" "salute.sber.ru" "smartmarket.sber.ru"
    "megamarket.sber.ru" "sberdevices.ru" "sbercloud.ru" "sberpay.ru" "pay.sber.ru"
    "ecom.sber.ru" "acquiring.sber.ru" "sbermarket.ru" "sberlogistics.ru"
    "sberid.ru" "sberhealth.ru" "sberinsurance.ru" "sberauto.ru"
    
    # ВТБ
    "vtb.ru" "vtb.com" "vtb24.ru" "online.vtb.ru" "mobile.vtb.ru"
    "api.vtb.ru" "my.vtb.ru" "web.vtb.ru" "id.vtb.ru" "auth.vtb.ru"
    "secure.vtb.ru" "login.vtb.ru" "cabinet.vtb.ru" "push.vtb.ru"
    "acquiring.vtb.ru" "payment.vtb.ru" "pay.vtb.ru" "vtb-online.ru"
    
    # Альфа-банк
    "alfabank.ru" "alfa-bank.ru" "alfakapital.ru" "online.alfabank.ru"
    "mobile.alfabank.ru" "api.alfabank.ru" "my.alfabank.ru" "web.alfabank.ru"
    "click.alfabank.ru" "pos.alfabank.ru" "payment.alfabank.ru" "acquiring.alfabank.ru"
    "alfa-click.ru" "alfaclick.ru" "auth.alfabank.ru" "secure.alfabank.ru"
    
    # Тинькофф
    "tinkoff.ru" "tcsbank.ru" "tcspay.com" "mobile.tinkoff.ru" "api.tinkoff.ru"
    "secure.tinkoff.ru" "form.tinkoff.ru" "partners.tinkoff.ru" "business.tinkoff.ru"
    "acdn.tinkoff.ru" "cdn.tinkoff.ru" "id.tinkoff.ru" "auth.tinkoff.ru"
    "journal.tinkoff.ru" "pro.tinkoff.ru" "invest-public-api.tinkoff.ru"
    "openapi.tinkoff.ru" "acquiring.tinkoff.ru" "payment.tinkoff.ru"
    
    # Другие банки
    "raiffeisen.ru" "raiffeisendirect.ru" "rconnect.ru"
    "gazprombank.ru" "gazprom-bank.ru" "gpb.ru"
    "rshb.ru" "rosbank.ru" "unicredit.ru"
    "uralsib.ru" "bspb.ru" "binbank.ru"
    "sovcombank.ru" "homecredit.ru" "crediteurope.ru"
    "citibank.ru" "jpmorgan.ru" "deutschebank.ru"
    "mts-bank.ru" "mtsbank.ru" "beeline-bank.ru"
    
    # === МОБИЛЬНЫЕ ОПЕРАТОРЫ ===
    "mts.ru" "mts.by" "api.mts.ru" "lk.mts.ru" "pay.mts.ru"
    "beeline.ru" "beeline.com" "my.beeline.ru" "uslugi.beeline.ru"
    "megafon.ru" "lk.megafon.ru" "api.megafon.ru" "service.megafon.ru"
    "tele2.ru" "tele2.com" "my.tele2.ru" "lk.tele2.ru"
    "yota.ru" "api.yota.ru" "lk.yota.ru"
    "rostelecom.ru" "rt.ru" "domru.ru" "ertelecom.ru"
    
    # === E-COMMERCE И МАРКЕТПЛЕЙСЫ ===
    # Авито
    "avito.ru" "www.avito.ru" "m.avito.ru" "mobile.avito.ru" "api.avito.ru"
    "avito.st" "cdn.avito.st" "static.avito.st" "img.avito.st" "pics.avito.st"
    "images.avito.st" "photo.avito.st" "avatars.avito.st" "upload.avito.st"
    "ssl.avito.ru" "secure.avito.ru" "auth.avito.ru" "id.avito.ru" "login.avito.ru"
    "cabinet.avito.ru" "my.avito.ru" "lk.avito.ru" "pro.avito.ru" "business.avito.ru"
    "chat.avito.ru" "messenger.avito.ru" "calls.avito.ru" "delivery.avito.ru"
    "pay.avito.ru" "payment.avito.ru" "wallet.avito.ru" "money.avito.ru"
    
    # Wildberries
    "wildberries.ru" "wb.ru" "static-basket-01.wb.ru" "basket-01.wb.ru"
    "card.wb.ru" "recommendations.wb.ru" "wbx.world" "seller.wildberries.ru"
    "suppliers.wildberries.ru" "analytics.wildberries.ru"
    
    # Ozon
    "ozon.ru" "ozon.com" "cdn1.ozone.ru" "cdn2.ozone.ru" "api.ozon.ru"
    "seller.ozon.ru" "performance.ozon.ru" "analytics.ozon.ru"
    
    # Другие маркетплейсы
    "lamoda.ru" "kupivip.ru" "joom.ru" "goods.ru" "citilink.ru"
    "dns-shop.ru" "mvideo.ru" "eldorado.ru" "technopark.ru"
    "svyaznoy.ru" "euroset.ru" "re-store.ru" "apple-rus.ru"
    "aliexpress.ru" "tmall.ru" "taobao.ru"
    
    # === ДОСТАВКА ЕДЫ И ТАКСИ ===
    "eda.yandex.ru" "delivery-club.ru" "deliveryclub.ru" "foodband.ru"
    "pizza-hut.ru" "dominos.ru" "kfc.ru" "mcdonalds.ru" "burgerking.ru"
    "taxi.yandex.ru" "citymobil.ru" "gett.ru" "uber.ru" "bolt.eu"
    "maxim.ru" "rutaxi.ru" "vezet.ru" "satom.ru"
    
    # === СТРИМИНГОВЫЕ СЕРВИСЫ ===
    "kinopoisk.ru" "ivi.ru" "ivi.tv" "more.tv" "start.ru" "wink.ru"
    "okko.tv" "premier.one" "amediateka.ru" "tvzavr.ru" "zoomak.ru"
    "rutube.ru" "vk.com/video" "smotrim.ru" "1tv.ru"
    "ntv.ru" "ren.tv" "tnt-online.ru" "ctc.ru" "tv3.ru"
    
    # === МУЗЫКАЛЬНЫЕ СЕРВИСЫ ===
    "music.yandex.ru" "zvooq.ru" "boom.ru" "zaycev.net" 
    
    # === ИГРЫ ===
    # World of Tanks экосистема
    "wargaming.net" "worldoftanks.ru" "worldofwarships.ru" "worldofwarplanes.ru"
    "wot.ru" "wows.ru" "wowp.ru" "tanki.su" "wotblitz.ru"
    
    # Gaijin Entertainment
    "gaijin.net" "warthunder.ru" "enlisted.net" "crossout.net"
    
    # Mail.ru Games / MY.GAMES
    "my.games" "mail.ru" "warface.ru" "allods.ru" "skyforge.ru"
    "armored-warfare.ru" "revelation-online.ru" "perfect-world.ru"
    "lineage2.ru" "archeage.ru" "blade-soul.ru" "tera-online.ru"
    
    # Российские игровые компании
    "nival.com" "1c.ru" "1c-game.ru" "owlcat.games" "mundfish.com"
    "targem.ru" "astrum-online.ru" "innova.ru" "playpark.ru"
    "gamexp.ru" "4game.com" "zzima.com" "gipat.ru"
    
    # === ГОСУДАРСТВЕННЫЕ СЕРВИСЫ ===
    "gosuslugi.ru" "esia.gosuslugi.ru" "lk.gosuslugi.ru" "beta.gosuslugi.ru"
    "nalog.gov.ru" "nalog.ru" "lkfl2.nalog.ru" "lkul.nalog.ru"
    "pfr.gov.ru" "es.pfrf.ru" "lk.pfrf.ru"
    "fss.ru" "lk.fss.ru" "cabfss.ru"
    "rosreestr.ru" "egrp365.ru" "kadastr.ru"
    "mos.ru" "lk.mos.ru" "md.mos.ru" "ag.mos.ru"
    "spb.ru" "gu.spb.ru" "petersburgedu.ru"
    "zakupki.gov.ru" "zakupki223.ru" "sberbank-ast.ru"
    
    # === ПРАВИТЕЛЬСТВЕННЫЕ САЙТЫ ===
    "kremlin.ru" "government.ru" "duma.gov.ru" "council.gov.ru"
    "ksrf.ru" "vsrf.ru" "genproc.gov.ru" "sledcom.ru"
    "mvd.ru" "fsb.ru" "svr.gov.ru" "fso.gov.ru" "rosgvardia.ru"
    "mchs.gov.ru" "mil.ru" "mid.ru" "minjust.gov.ru"
    "minfin.gov.ru" "economy.gov.ru" "minenergo.gov.ru"
    "minpromtorg.gov.ru" "minstroyrf.gov.ru" "mintrans.gov.ru"
    "minzdrav.gov.ru" "minobr.gov.ru" "minobrnauki.gov.ru"
    "roskomnadzor.ru" "rkn.gov.ru" "fas.gov.ru" "cbr.ru"
    
    # === НОВОСТНЫЕ САЙТЫ ===
    "ria.ru" "tass.ru" "rt.com" "gazeta.ru" "lenta.ru" "rbc.ru"
    "interfax.ru" "regnum.ru" "rosbalt.ru" "fontanka.ru"
    "kp.ru" "mk.ru" "aif.ru" "kommersant.ru" "vedomosti.ru"
    "izvestia.ru" "rg.ru" "ng.ru" "business-gazeta.ru"
    "1tv.ru" "ntv.ru" "vesti.ru" "lifenews.ru" "life.ru"
    
    # === ОБРАЗОВАНИЕ И IT ===
    "habr.com" "tproger.ru" "proglib.io" "vc.ru" "rb.ru"
    "geekbrains.ru" "netology.ru" "skillbox.ru" "skillfactory.ru"
    "stepik.org" "coursera.org" "udemy.com" "edx.org"
    "msu.ru" "spbu.ru" "hse.ru" "mephi.ru" "mipt.ru"
    "bmstu.ru" "itmo.ru" "urfu.ru" "nstu.ru" "mirea.ru"
    
    # === ЗДОРОВЬЕ ===
    "docdoc.ru" "prodoctorov.ru" "sberhealth.ru" "k-d.ru"
    "invitro.ru" "helix.ru" "cmd-online.ru" "gemotest.ru"
    "gorzdrav.org" "apteka.ru" "366.ru" "piluli.ru"
    
    # === ФИНАНСЫ И КРИПТОВАЛЮТЫ ===
    "finam.ru" "bcs.ru" "tinkoff.ru" "alfa-capital.ru"
    "vtb-capital.ru" "sberbank-cib.ru" "gazprombank.ru"
    "garantex.io" "currency.com"
    "yobit.net" "livecoin.net" "matbea.com" "btc-trade.com.ua"
    
    # === НЕДВИЖИМОСТЬ ===
    "cian.ru" "domclick.ru" "etagi.com" "bn.ru" "move.ru"
    "zhk.ru" "novostroy-m.ru" "flatfy.ru" "domofond.ru"
    
    # === АВТОМОБИЛИ ===
    "auto.ru" "drom.ru" "am.ru" "cars.ru" "avito.ru/transport"
    "carprice.ru" "bibika.ru" "autospot.ru" "kolesa.ru"
    
    # === РАБОТА ===
    "hh.ru" "headhunter.ru" "superjob.ru" "rabota.ru" "zarplata.ru"
    "career.ru" "freelance.ru" "fl.ru" "weblancer.net" "kwork.ru"
    
    # === CDN И ТЕХНИЧЕСКИЕ ДОМЕНЫ ===
    "imgsmail.ru"
)

# Создаем главную цепочку
echo "Создаем цепочку BLOCK_ALL_RUSSIAN..."
sudo iptables -N BLOCK_ALL_RUSSIAN 2>/dev/null || true
sudo iptables -F BLOCK_ALL_RUSSIAN

total_domains=0
total_ips=0
total_ranges=0

echo "============================================"
echo "НАЧИНАЕМ ПОЛНУЮ БЛОКИРОВКУ РОССИИ"
echo "Доменов для обработки: ${#ALL_RUSSIAN_DOMAINS[@]}"
echo "============================================"

# Блокируем домены
echo ""
echo "Этап 1/3: Блокируем домены российских сервисов..."
for domain in "${ALL_RUSSIAN_DOMAINS[@]}"; do
    echo "Обрабатываем: $domain"
    
    # Получаем IPv4 адреса
    ipv4_list=$(dig +short $domain A | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -5)
    
    for ip in $ipv4_list; do
        if [ ! -z "$ip" ]; then
            echo "  -> Блокируем IPv4: $ip"
            sudo iptables -A BLOCK_ALL_RUSSIAN -d $ip -j REJECT --reject-with icmp-net-unreachable
            ((total_ips++))
        fi
    done
    
    # Получаем IPv6 адреса (если есть поддержка)
    ipv6_list=$(dig +short $domain AAAA 2>/dev/null | grep -E '^[0-9a-f:]+$' | head -3)
    
    for ipv6 in $ipv6_list; do
        if [ ! -z "$ipv6" ]; then
            echo "  -> Блокируем IPv6: $ipv6"
            sudo ip6tables -A BLOCK_ALL_RUSSIAN -d $ipv6 -j REJECT --reject-with icmp6-addr-unreachable 2>/dev/null || true
        fi
    done
    
    ((total_domains++))
    
    # Пауза для DNS
    sleep 0.05
done

echo ""
echo "Этап 3/3: Дополнительные блокировки..."

# Блокируем популярные российские DNS серверы
echo "Блокируем российские DNS серверы..."
sudo iptables -A BLOCK_ALL_RUSSIAN -d 77.88.8.8 -j REJECT      # Yandex DNS
sudo iptables -A BLOCK_ALL_RUSSIAN -d 77.88.8.1 -j REJECT      # Yandex DNS
sudo iptables -A BLOCK_ALL_RUSSIAN -d 77.88.8.88 -j REJECT     # Yandex DNS Family
sudo iptables -A BLOCK_ALL_RUSSIAN -d 77.88.8.2 -j REJECT      # Yandex DNS Family
sudo iptables -A BLOCK_ALL_RUSSIAN -d 77.88.8.7 -j REJECT      # Yandex DNS Safe
sudo iptables -A BLOCK_ALL_RUSSIAN -d 77.88.8.3 -j REJECT      # Yandex DNS Safe

echo "Подключаем цепочку BLOCK_ALL_RUSSIAN к iptables..."

# Удалим старые подключения, если были
sudo iptables -D OUTPUT -j BLOCK_ALL_RUSSIAN 2>/dev/null || true
sudo iptables -D FORWARD -j BLOCK_ALL_RUSSIAN 2>/dev/null || true

echo ""
echo "Блокировка завершена."
echo "Заблокировано доменов: $total_domains"
echo "Заблокировано IPv4 адресов: $total_ips"
echo "Заблокировано IP-диапазонов: $total_ranges"

# Подключаем цепочку к OUTPUT и FORWARD
sudo iptables -I OUTPUT 1 -j BLOCK_ALL_RUSSIAN
sudo iptables -I FORWARD 1 -j BLOCK_ALL_RUSSIAN
