import requests
# find and save the current Github release
html = str(
    requests.get('https://github.com/kiali/kiali/releases/latest')
    .content)
index = html.find('Release ')
github_version = html[index + 15:index + 21].replace('<', '').replace(' ', '').replace('\\', '')
file = open('github_version.txt', 'w')
file.writelines(github_version)
file.close()

# find and save the current Bazel version on FTP server
html = str(
    requests.get(
        'https://oplab9.parqtec.unicamp.br/pub/ppc64el/kiali/latest'
    ).content)
index = html.rfind('kiali-')
ftp_version = html[index + 6:index + 12].replace('<', '').replace(' ', '').replace('\\', '')
file = open('ftp_version.txt', 'w')
file.writelines(ftp_version)
file.close()

# find and save the oldest Bazel version on FTP server
index = html.find('kiali-')
delete = html[index + 6:index + 12].replace('<', '').replace(' ', '').replace('\\', '')
file = open('delete_version.txt', 'w')
file.writelines(delete)
file.close()
