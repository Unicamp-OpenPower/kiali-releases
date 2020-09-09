github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)
github_version=1.22.0

if [ $github_version != $ftp_version ]
then
    cd $GOPATH/src/github.com
    mkdir kiali
    cd kiali
    wget https://github.com/kiali/kiali/archive/v$github_version.zip
    unzip v$github_version.zip
    mv kiali-$github_version kiali
    git clone https://github.com/kiali/kiali-operator.git kiali/operator
    git clone https://github.com/kiali/kiali-operator.git kiali/helm-charts
    cd kiali
    make build
    cd $GOPATH/bin
    mv kiali kiali-$github_version
    ls
    ./kiali-$github_version -help

    if [[ $github_version != $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kiali/latest kiali-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kiali/latest/kiali-$ftp_version"
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kiali kiali-$github_version"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kiali/kiali-$del_version"
fi
