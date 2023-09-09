
```
gpg --batch --gen-key .config/key-script

or gpg full-generate-key to manually specify steps. 

chmod 600 ~/.gnupg/*

chmod 700 ~/.gnupg

gpg --list-secret-keys --with-colons | awk -F: '$1 == "fpr" || $1 == "fp2" {print $10}' | awk 'NR==1 {print $1}'

SECRET_KEY=$(gpg --list-secret-keys --with-colons | awk -F: '$1 == "fpr" || $1 == "fp2" {print $10}' | awk 'NR==1 {print $1}')

pass init $SECRET_KEY

pass insert docker-credential-helpers/docker-pass-initialized-check

cargo install exa bat

cp tokyo-night-status.conf .tmux/plugins/tokyo-night-tmux/src/tokyo-night-status.conf
- consider forking this so we can keep the customization

```
