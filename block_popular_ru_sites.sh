#!/bin/bash

# Скрипт для блокировки популярных российских сайтов на уровне сервера

echo "Настраиваем блокировку популярных российских сайтов..."

# Список популярных российских сайтов
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

# Создаем новую цепочку
sudo iptables -N BLOCK_RU_POPULAR 2>/dev/null || true
sudo iptables -F BLOCK_RU_POPULAR

count=0

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
    sleep 0.5
done

# Применяем цепочку к исходящему и пересылаемому трафику
sudo iptables -I OUTPUT -j BLOCK_RU_POPULAR
sudo iptables -I FORWARD -j BLOCK_RU_POPULAR

echo ""
echo "Блокировка настроена!"
echo "Заблокировано $count IP-адресов популярных российских сайтов"
echo ""
echo "Для просмотра заблокированных правил:"
echo "sudo iptables -L BLOCK_RU_POPULAR -v"
echo ""
echo "Для удаления блокировки:"
echo "sudo iptables -D OUTPUT -j BLOCK_RU_POPULAR"
echo "sudo iptables -D FORWARD -j BLOCK_RU_POPULAR"
echo "sudo iptables -F BLOCK_RU_POPULAR"
echo "sudo iptables -X BLOCK_RU_POPULAR"