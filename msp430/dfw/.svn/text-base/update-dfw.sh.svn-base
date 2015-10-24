#!/bin/sh
repos=file:///Volumes/data/skimu/svnrepos

if [ $# != 1 ]; then
        echo "usage:" $0 "dfw-x.y"
        exit 1
fi

rel=$1
echo "Makeing release," ${rel}
echo "svn copy"
svn copy ${repos}/msp430/dfw ${repos}/msp430/${rel} -m "Release ${rel}"
echo "svn checkout"
svn checkout ${repos}/msp430/${rel}
echo "deleting .svn"
find ${rel} -name .svn -exec rm -rf {} \;
echo "making tgz"
tar zcvf ${rel}.tgz ${rel}
cp ${rel}/README README.txt
