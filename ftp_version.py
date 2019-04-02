html = str(
    requests.get('https://github.com/kiali/kiali/releases/latest')
    .content)
index = html.find('Release ')
github_version = html[index + 14:index + 20]
file = open('github_version.txt', 'w')
file.writelines(github_version)
file.close()

# find and save the current Bazel version on FTP server
html = str(
    requests.get(
        'https://oplab9.parqtec.unicamp.br/pub/ppc64el/kiali/'
    ).content)
index = html.rfind('kiali-')
ftp_version = html[index + 6:index + 12]
file = open('ftp_version.txt', 'w')
file.writelines(ftp_version)
file.close()

# find and save the oldest Bazel version on FTP server
index = html.find('kiali-')
delete = html[index + 6:index + 12]
file = open('delete_version.txt', 'w')
file.writelines(delete)
file.close()
