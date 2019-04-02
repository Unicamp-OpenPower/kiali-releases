github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    wget https://oplab9.parqtec.unicamp.br/pub/ppc64el/glide/glide-0.13.1
    mv glide-0.13.1 glide
    sudo chmod 755 glide
    sudo mv glide /usr/bin/glide
  
    cd $GOPATH/src/github.com
    mkdir kiali
    cd kiali
    wget https://github.com/kiali/kiali/archive/v$github_version.zip
    unzip v$github_version.zip
    mv kiali-$github_version kiali
    cd kiali 
    rm Makefile
    mv /home/travis/gopath/src/github.com/Unicamp-OpenPower/kiali-releases/Makefile $GOPATH/src/github.com/kiali/kiali/Makefile
    make build
    make test
    cd $GOPATH/bin
    mv kiali kiali-$github_version
    
    if [[ $github_version > $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kiali/latest kiali-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kiali/latest/kiali-$ftp_version" 
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kiali kiali-$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kiali/kiali-$del_version" 
fi
