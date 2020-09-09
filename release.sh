#!/usr/bin/env bash
github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
github_version=1.21.0
LOCALPATH=$GOPATH/src/github.com/kiali/kiali
BINPATH=$GOPATH/bin

if [ $github_version != $ftp_version ]
then
  git clone https://$USERNAME:$TOKEN@github.com/Unicamp-OpenPower/repository-scrips.git
  cd repository-scrips/
  chmod +x empacotar-deb.sh
  chmod +x empacotar-rpm.sh
  sudo mv empacotar-deb.sh $BINPATH
  sudo mv empacotar-rpm.sh $BINPATH
  cd $BINPATH
  sudo ./empacotar-deb.sh kiali kiali-$github_version $github_version " "
  sudo ./empacotar-rpm.sh kiali kiali-$github_version $github_version " " "Kiali project, observability for the Istio service mesh"
  if [ $github_version > $ftp_version ]
  then
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/debian/ppc64el/kiali/ $BINPATH/kiali-$github_version-ppc64le.deb"
    sudo lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/rpm/ppc64le/kiali/ ~/rpmbuild/RPMS/ppc64le/kiali-$github_version-1.ppc64le.rpm"
  fi
fi
