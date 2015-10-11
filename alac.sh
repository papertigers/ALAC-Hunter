#!/usr/bin/env bash

music_dir="/Users/link/Music/iTunes/iTunes Media/Music"
fake_music_dir="/Users/link/Music/iTunes/iTunes Media/Fake_Music"
alac_identifier="Apple Lossless Audio Codec"


mirrorDirStructure() {
  find . -type d -exec mkdir -p "$fake_music_dir"/"{}" \; 
}

findAndSymlinkALAC() {
	#files=`find . -type f -iname "*.m4a"` 
	while read -r musicfile
	do 
			mediainfo "$musicfile" | grep "$alac_identifier" > /dev/null && ln -s "$music_dir"/"$musicfile" "$fake_music_dir"/"$musicfile" > /dev/null 2>&1
	done < <(find . -type f -iname "*.m4a" | sed "s|^\./||") 
}

pruneEmptyDirs() {
	#We have sync'd up all known ALAC music so we should tidy up
	find . -depth -type d -empty -exec rmdir "{}" \;
}

#Start off in the iTunes Managed Music dir
cd "$music_dir" || exit 1
mirrorDirStructure
findAndSymlinkALAC

#Tidy up the fake music dir
cd "$fake_music_dir" || exit 1
pruneEmptyDirs()
