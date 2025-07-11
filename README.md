## Installation
(assuming backup.tar.gz is in root home directory)
```
su -
git clone "https://github.com/louismachin/site" /opt/machin.dev
tar -xzf ~/backup.tar.gz -C /opt/machin.dev
apt-get update
apt-get install ruby-dev build-essential
cd /opt/machin.dev
bundle install
ruby ./start.rb
```
