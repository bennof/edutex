#!/bin/sh

VERSION=0.20a
YEAR=2015
AUTHOR="Benno Falkner <benno@benjaminfalkner.de>"

FEXT="etx"


SOURCE=$0
while [ -h "$SOURCE" ]; do
	SDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$SDIR/$SOURCE"
done
SDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
SDIR="$(cd $SDIR/.. && pwd)"
#echo ">>>>> $SDIR"

cat <<END
eduTeX - Shell - $VERSION
Copyright (c) $YEAR, $AUTHOR
All rights reserved.

Released under BSD License (3 clause)
END

set -xe

help () {
cat <<END
Help:

usage: edutex <mode> [args] <file>

Modes:
  help            print this help
  info	          print information
  tex	  <file>  typeset an input file
  install [args]  installer for EduTeX (Make, UNIX)
       -c         clean / remove all tmp files
       -i         install files
       -d <path>  install path (default: /opt/edutex) 

END
}

info () {
help
cat <<END


=== License

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=== Info

EduTeX is using TeX as typsetting system written by Donald Knuth. In this 
version only pdfTeX is supported written by Hàn Thế Thành. 

The TeX program is based on plain TeX and not compatible with conTeX or LaTeX. 


=== ToDo
a lot
... 
END
}


install () {
	DIR=$(pwd)
	INSTALLDIR="/opt/edutex"

	DIR=$DIR/edutex.$(date +%s).tmp
	while (( "$#" )); do
		case $1 in
			-c) trap 'rm -r "$DIR" || echo "No tmp directory"' EXIT INT QUIT TERM HUP;;
			-d) shift; DIR=$1 ;;
			-i) inst=1;;	
		esac
		shift
	done

	#check if file is in downloaded git or standalone 
	GIT=""
	if [ -f "$SDIR/LICENSE" ] ; then 
		read -r firstline < $SDIR/LICENSE
		#echo ">>> $firstline"
		if [ "${firstline%% *}" == "eduTeX" ]; then
			GIT=1
		fi
		#cat $HDIR/../LICENSE
	fi

	if [ -z "$GIT" ]; then
		echo "try downloading git archive"
		mkdir -p $DIR
		cd $DIR
	else
		echo "using git archive"
		DIR="$SDIR"
	fi

	#build
	make clean; make


	#copy to install dir
	if [ -z "$inst" ]; then
		echo "no install"
		INSTALLDIR=$DIR
	else
		echo "install: $INSTALLDIR"
		sudo mkdir -p $INSTALLDIR
		sudo make install
	fi

	#end
	echo "Add the following line to your profile or rc file:" 
	echo "export PATH=$INSTALLDIR/bin:\$PATH"
	exit 0
}

setuptex () {
	
	export TEXINPUTS=.:$SDIR/tex/:$TEXINPUTS
	export TFMFONTS=.:$SDIR/tex/fonts/:$TFMFONTS
	export TEXFORMATS=.:$SDIR/tex/fmt/:$TEXFORMATS
}

new () {
	if [ -z "$1" ]; then
		echo "Unkown file or directory"; exit 1
	fi

	if [ "${1##*\.}" == "$FEXT" ]; then 
		DIR=${1%%.*}
		FILE=$1
	else
		DIR="$1"
		FILE="$1.$FEXT"
	fi

	if [ -d "$DIR" ]; then
		echo "Directory exists"; exit 1
	fi

	if [ -d "$SDIR/config" ]; then 
		echo "global eduTeX folder found"
	fi
	if [ -d "~/.edutex" ]; then 
		echo "local eduTeX folder found"
	fi


	mkdir -p $DIR/{img,.tex,.data,.fonts}
}

pack () { 
	if [ -z "$1" ]; then
		echo "Unkown file or directory"; exit 1
	fi

	if [ "${1##*\.}" == "$FEXT" ]; then 
		DIR=${1%%.*}
		FILE=$1
	else
		DIR="$1"
		FILE="$1.$FEXT"
	fi

	if [ -d "$DIR" ]; then
		echo "packing eduTeX: $DIR > $FILE"
		zip -r $FILE $DIR 
	else
		echo "Directory not found"; exit 1
	fi
}

unpack () { 
	if [ -z "$1" ]; then
		echo "Unkown file or directory"; exit 1
	fi

	if [ "${1##*\.}" == "$FEXT" ]; then 
		DIR=${1%%.*}
		FILE=$1
	else
		DIR="$1"
		FILE="$1.$FEXT"
	fi

	if [ -d "$DIR" ]; then 
		echo "Directory exists - Override ? (y/n)"; 
		read or
		if [ "${or#1}" == "y" ] || [ "${or#1}" == "Y" ]; then 
			echo "override!!!"
		else
			exit 1
		fi 
	fi

	if [ -f "$FILE" ]; then
		echo "unpacking eduTeX: $FILE > $DIR"
		unzip $FILE 
	else
		echo "File not found"; exit 1
	fi
}


texzip (){
	echo "missing"
}

texdir (){
	echo "missing"
}

tex () {
	. setuptex
	echo "missing" 
	exit 0
}

MODE=$1
shift || { echo "No MODE selected" ; help;  exit 1; }
case "$MODE" in
	help) help; exit 0;;
	info) info; exit 0;;
	tex) tex $@;;
	unpack) unpack $@;;
	pack) pack $@;;
	new) new $@;;
	install) install $@;;
	*) echo "No/Unkown MODE selected"; help;  exit 1 ;;
esac
