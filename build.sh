#!/bin/sh
printf "Two versions of arieljs will be build:\n-) with touch support (bin/arieljs)\n-) without (bin/arieljs-notouch)\n"

printf "Removing old binaries\n\n"
rm -f bin/phantomjs
rm -f bin/arieljs
rm -f bin/arieljs-notouch

printf "Building ariel without touch support. QtBase and QtWebkit will be rebuilt\n\n"
patch -f -i notouch.patch src/qt/qtwebkit/Tools/qmake/mkspecs/features/features.pri

python build.py --git-clean-qtbase --git-clean-qtwebkit --qt-config "-D ENABLE_TOUCH_EVENTS=0" --release --confirm
if [ -f bin/phantomjs ];
then
   mv bin/phantomjs bin/arieljs-notouch
else
   echo "Build no touch failed"
   exit 1
fi

printf "Building ariel with touch support. QtBase and QtWebkit will be rebuilt\n\n"
patch -fR -i notouch.patch src/qt/qtwebkit/Tools/qmake/mkspecs/features/features.pri
make clean
python build.py --git-clean-qtbase --git-clean-qtwebkit --release --confirm
if [ -f bin/phantomjs ];
then
   mv bin/phantomjs bin/arieljs
else
   echo "Build touch failed"
   exit 1
fi