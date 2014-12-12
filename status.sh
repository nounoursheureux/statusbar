#!/usr/bin/env sh

Vol() {
    mute=$(amixer get Master | grep Mono: | cut -d " " -f 8)
    if [[ $mute == "[off]" ]]; then
        echo -n "^ca(1,./volume_popup)^fg(orange)^i("icons/spkr_02.xbm") : Muet ^fg()^ca()| "
    else 
        volume=$(amixer get Master | grep Mono: | cut -d " " -f 6 | sed -s 's/\[\(.*\)%\]/\1/')
        volume_bar=$(echo $volume | gdbar -h 2 -w 50 -fg orange)
        echo -n "^ca(1,./volume_popup)^fg(orange)^i("icons/spkr_01.xbm") : $volume_bar ^fg()^ca()| "
    fi
    return
}

Wifi() {
    ssid=$(iwconfig wlp11s0 |grep ESSID| awk '{print $NF}'|cut -d ":" -f 2)
    ip=$(ifconfig wlp11s0 |grep 192|grep inet)
    ip=$(echo $ip|cut -d " " -f 2)
    echo -n "^fg(purple)^i(icons/wifi_02.xbm) : $ssid  $ip ^fg()| "
    return
}

Battery() {
    charge=$(acpi|cut -d "," -f 2)
    echo -n "^fg(yellow)^i(icons/bat_full_02.xbm) : $charge^fg() | "
    return
}

Disk() {
    space=$(df -h /home|sed '1d'|awk '{print $5}' | sed 's/\(.*\)%/\1/')
    space_bar=$(echo $space | gdbar -h 2 -w 50 -fg green)
    echo -n "^ca(1, ./disk_popup)^fg(green)^i(icons/diskette.xbm) : $space_bar ^fg()^ca()| "
    return
}

Time() {
    hour=$(date +"%H:%M:%S")
    date=$(date +"%a %d %b")
    echo -n "^ca(1,./fortune_popup)^fg(red)$date ^fg()^ca()| ^ca(1,./clock_popup)^i(icons/clock.xbm) : $hour^ca()"
    return
}

Music() {
    play=$(mpc current)
    if [[ $play ]]; then
        echo -n "^fg(blue)^ca(1, ./music_popup)^i(icons/note.xbm) : $play^ca()^fg() | "
    fi
    return
}

Update() {
    updates=$(wc -l < ~/updates)
    echo -n "^ca(1,./update_popup)^fg(#4BB5C1)^i(icons/arch.xbm) : $updates^fg()^ca() | "
}

Mail() {
    mailnbr=$(cat ~/newmail)
    if [[ ! -f ~/newmail ]]; then
        touch ~/newmail
    fi
    if [[ $mailnbr != "0" ]]; then
        echo -n " | ^fg(#FF358B)^i(icons/mail.xbm) : $mailnbr^fg()"
    fi
}

Print () {
    Vol
    Disk
    Wifi
    #Battery
    Music
    Update
    Time
    Mail
    echo
    return
}

while true 
do
    sleep 1
    echo "$(Print)" 
done | dzen2 -p -fn  -*-ohsnapu-medium-r-normal-*-11-*-*-*-*-*-*-* -dock 

