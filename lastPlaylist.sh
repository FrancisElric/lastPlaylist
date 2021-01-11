#!/bin/bash

#lastPlaylist.sh Francis_El recommended
curl https://www.last.fm/player/station/user/$1/$2 | jq > cache.tempLast
grep -oP 'https:\/\/www\.youtube\.com/watch\?v=.{11}' cache.tempLast | sed -e n\;d > url.tempLast 
grep -oP '(?<=\"name\": \").*?(?=\")' cache.tempLast > meta.tempLast
grep -oP '(?<=\"id\": \").*?(?=\")' cache.tempLast | sed -e n\;d > tags.tempLast 
youtube-dl -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --autonumber-start 1 -a url.tempLast -o "%(autonumber)s.%(title)s."
ls | grep -P '\.*.mp3' > list.tempLast
j=1
for ((i = 1 ; i < $(wc -l meta.tempLast | grep -oP '\d+') ; (i=i+2))); 
	do eyeD3 -a "$(sed -n ${i}p meta.tempLast)" -t "$(sed -n $((${i} + 1))p meta.tempLast)" -c "$(sed -n ${j}p tags.tempLast)" "$(sed -n ${j}p list.tempLast)"
done
rm *.tempLast