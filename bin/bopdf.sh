#!/bin/bash
title="undefined"
subtitle=""
author="Timon Schröder"
toc="--toc"
today=$(date +'%Y-%m-%d')

while getopts "s:t:a:T" opt; do
  case $opt in
    s)
      if [ "$OPTARG" != "" ]; then
      	subtitle="$OPTARG"
	  fi
      ;;
    t)
      if [ "$OPTARG" != "" ]; then
      	title="$OPTARG"
	  fi
      ;;
    a)
      if [ "$OPTARG" != "" ]; then
      	author="$OPTARG"
	  fi
      ;;
	T)
      	toc=""
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

for var in "$@"
do
    if [ -f "$var" ] && [[ "$var" =~ \.md ]]; then
    	file=$var;
    fi
done

if ! [ -f "$file" ]; then
	echo "No input file given."
	echo 'Usage: bopdf.sh [-t "Title"] [-s "Subtitle"] [-a "Author"] [-T] file'
	exit 1;
fi

output=$( tr '[A-ZÄÜÖ]' '[a-zäüö]' <<< $title )
output=$(sed "s/ /-/g" <<< "$output")
output=$(sed "s/ä/ae/g" <<< "$output")
output=$(sed "s/ö/oe/g" <<< "$output")
output=$(sed "s/ü/ue/g" <<< "$output")
output=$(sed "s/ß/ss/g" <<< "$output")
output="$today-BERLINONLINE-$output.pdf"
#output="$today-BERLINONLINE-$output.docx"


echo "Source File: $file"
echo "Title: $title"
echo "Subtitle: $subtitle"
echo "Author: $author"
echo "Creating $output"

pandoc  -S --toc --toc-depth=5 "$file" -o "$output"  -V subtitle="$subtitle" -V documentclass=scrartcl -V author="$author" -V title="$title" --template=/home/timon/BerlinOnline/4_other/bo_pdf/template.tex  -V lang=german $toc
