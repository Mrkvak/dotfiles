#!/bin/sh
sed -i \
         -e 's/#2b303b/rgb(0%,0%,0%)/g' \
         -e 's/#efefef/rgb(100%,100%,100%)/g' \
    -e 's/#2b303b/rgb(50%,0%,0%)/g' \
     -e 's/#0096c8/rgb(0%,50%,0%)/g' \
     -e 's/#2b303b/rgb(50%,0%,50%)/g' \
     -e 's/#efefef/rgb(0%,0%,50%)/g' \
	"$@"
