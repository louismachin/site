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

## Service

```
sudo ln -s /opt/cdn/louismachin.service /etc/systemd/system/louismachin.service
sudo systemctl daemon-reload
sudo systemctl enable louismachin.service
sudo systemctl start louismachin.service


sudo journalctl -u louismachin.service -n 50
sudo journalctl -u louismachin.service -f
```
