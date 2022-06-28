#!/bin/bash

RESIZE_TG="512x512";
RESIZE_ALL=$RESIZE_TG;
RESIZE_COVER="100x100";

rm -rf temp_folder;
mkdir temp_folder;

rm -rf gif;
mkdir gif;

rm -rf webm;
mkdir webm;

for arms in png/arms/*; do
	arms_name=$( basename $arms )
	for type in $arms/*; do
		type_name=$( basename $type )

		# crop 
		crop="1920x1080+0+0";
		if [[ "$arms_name" == "arms_crossed" ]]; then
			crop="794x1080+58+0";
		fi

		if [[ "$arms_name" == "arms_down" ]]; then
			crop="716x1080+137+0";
		fi

		if [[ "$arms_name" == "one_arm" ]]; then
			crop="937x1080+66+0";
		fi

		# versions count
		versions="1 2";
		if [[ "$arms_name" == "arms_crossed" ]] && [[ "$type_name" == "nerv" ]]; then
			versions="1";
		fi

		if [[ "$arms_name" == "arms_crossed" ]] && [[ "$type_name" == "zout" ]]; then
			versions="1";
		fi

		if [[ "$type_name" == "neutral" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "arms_down" ]] && [[ "$type_name" == "conf" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "one_arm" ]] && [[ "$type_name" == "conf" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "arms_down" ]] && [[ "$type_name" == "mad" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "one_arm" ]] && [[ "$type_name" == "mad" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "arms_down" ]] && [[ "$type_name" == "sad" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "one_arm" ]] && [[ "$type_name" == "sad" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "arms_down" ]] && [[ "$type_name" == "smile" ]]; then
			versions="1 2 3";
		fi

		if [[ "$arms_name" == "one_arm" ]] && [[ "$type_name" == "smile" ]]; then
			versions="1 2 3";
		fi


		# generating
		for version in $versions; do
			# telegram have problems with packed ffmpeg(?) libs sooo... we must do:
			# 3 frames png -> gif -> N frames png -> webm
			convert \
				-loop 0 \
				"$type/$type_name"_"$version".png -delay 691x100 \
				"$type/$type_name"_"$version"_eyes_open.png -delay 11x100 \
				"$type/$type_name"_"$version"_eyes_half.png -delay 11x100 \
				"$type/$type_name"_eyes_closed.png -delay 11x100 \
				"$type/$type_name"_"$version"_eyes_half.png -delay 11x100 \
				"$type/$type_name"_"$version"_eyes_open.png -delay 11x100 \
				-crop $crop \
				+repage \
				-resize $RESIZE_ALL \
				gif/"$arms_name"_"$type_name"_"$version".gif
			rm temp_folder/*
			ffmpeg -y -i gif/"$arms_name"_"$type_name"_"$version".gif temp_folder/%04d.png
			convert \
				-loop 0 \
				-delay 3x101 \
				temp_folder/* \
				gif/"$arms_name"_"$type_name"_"$version".gif
			ffmpeg -y -i gif/"$arms_name"_"$type_name"_"$version".gif -c vp9 -b:v 0 -crf 0 -pix_fmt yuva420p -lossless 1 -compression_level 0 -loop 0 webm/"$arms_name"_"$type_name"_"$version".webm
		done
	done
done


### funny
convert \
	-loop 0 \
	"png/arms/arms_crossed/smile/smile_funny.png" -delay 11 \
	-crop 794x1080+58+0 \
	+repage \
	-resize $RESIZE_ALL \
	gif/"arms_crossed"_"funny".gif

ffmpeg -y -i gif/"arms_crossed"_"funny".gif -c vp9 -b:v 0 -crf 0 -pix_fmt yuva420p -lossless 1 -compression_level 0 -loop 0 webm/"arms_crossed"_"funny".webm

### dream
convert \
	-loop 0 \
	"png/cg_dream/2.png" -delay 245 \
	"png/cg_dream/eyes_open.png" -delay 11 \
	"png/cg_dream/eyes_half.png" -delay 11 \
	"png/cg_dream/eyes_closed.png" -delay 11 \
	"png/cg_dream/eyes_half.png" -delay 11 \
	"png/cg_dream/eyes_open.png" -delay 11 \
	+repage \
	-resize $RESIZE_ALL \
	gif/"dream".gif
rm temp_folder/*
ffmpeg -y -i gif/"dream".gif temp_folder/%04d.png
convert \
	-loop 0 \
	-delay 3x101 \
	temp_folder/* \
	gif/"dream".gif
ffmpeg -y -i gif/"dream".gif -c vp9 -b:v 0 -crf 0 -pix_fmt yuva420p -lossless 1 -compression_level 0 -loop 0 webm/"dream".webm

### sleep 
convert \
	-loop 0 \
	"png/cg_dream/1.png" -delay 1 \
	+repage \
	-resize $RESIZE_ALL \
	gif/"sleep".gif
rm temp_folder/*
ffmpeg -y -i gif/"sleep".gif temp_folder/%04d.png
convert \
	-loop 0 \
	-delay 3x101 \
	temp_folder/* \
	gif/"sleep".gif
ffmpeg -y -i gif/"sleep".gif -c vp9 -b:v 0 -crf 0 -pix_fmt yuva420p -lossless 1 -compression_level 0 -loop 0 webm/"sleep".webm

### cover
convert \
	-loop 0 \
	"png/arms/arms_crossed/smile/smile_1.png" -delay 245 \
	"png/arms/arms_crossed/smile/smile_1_eyes_open.png" -delay 11 \
	"png/arms/arms_crossed/smile/smile_1_eyes_half.png" -delay 11 \
	"png/arms/arms_crossed/smile/smile_eyes_closed.png" -delay 11 \
	"png/arms/arms_crossed/smile/smile_1_eyes_half.png" -delay 11 \
	"png/arms/arms_crossed/smile/smile_1_eyes_open.png" -delay 11 \
	-crop 550x550+175+25 \
	-resize $RESIZE_COVER \
	+repage \
	gif/"cover".gif
rm temp_folder/*
ffmpeg -y -i gif/"cover".gif temp_folder/%04d.png
convert \
	-loop 0 \
	-delay 3x101 \
	temp_folder/* \
	gif/"cover".gif
ffmpeg -y -i gif/"cover".gif -c vp9 -b:v 0 -crf 0 -pix_fmt yuva420p -lossless 1 -compression_level 0 -loop 0 webm/"cover".webm


# temp files removing
#rm -f gif/*.gif
rm -f gif/*_uncut.webm
rm -rf temp_folder

