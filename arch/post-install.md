
```
gpg --batch --gen-key .config/key-script

or gpg full-generate-key to manually specify steps. 

gpg --list-secret-keys --with-colons | awk -F: '$1 == "fpr" || $1 == "fp2" {print $10}' | awk 'NR==1 {print $1}'

SECRET_KEY=$(gpg --list-secret-keys --with-colons | awk -F: '$1 == "fpr" || $1 == "fp2" {print $10}' | awk 'NR==1 {print $1}')

pass init $SECRET_KEY

pass insert docker-credential-helpers/docker-pass-initialized-check


yay -s rate-mirrors

yay -S rxvt-unicode-pixbuf

cargo install bat du-dust lsd miniserver speedtest-rs

```
