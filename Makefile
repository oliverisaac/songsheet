upload:
	rsync -rtuv ./ isaacinit.com:/app/www/isaacinit.com/www/songsheet --delete

pull: 
	rsync -rtuv isaacinit.com:/app/www/isaacinit.com/www/songsheet/. ./

open:
	open https://isaacinit.com/songsheet/

lyrics.js:
	./generate-lyrics.sh | tee lyrics.js
