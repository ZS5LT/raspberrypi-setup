# Install node
cd ~/
wget http://node-arm.herokuapp.com/node_latest_armhf.deb 
sudo dpkg -i node_latest_armhf.deb

# Clone Homebridge
cd /opt
sudo git clone https://github.com/nfarina/homebridge.git
sudo chown -fR $USER:staff homebridge
cd /opt/homebridge
git submodule init
git submodule update
npm install
cd lib/HAP-NodeJS
npm install

# Install forever package
sudo npm install -g forever

# Set up init.d job to keep it running
sudo touch /etc/init.d/homebridge
sudo chmod a+x /etc/init.d/homebridge
sudo update-rc.d homebridge defaults

# Create a temporary init.d script then move it into place
cat << 'EOF' > /tmp/homebridge-launch-tmp
#!/bin/sh

export PATH=$PATH:/usr/local/bin
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export SERVER_PORT=80
export SERVER_IFACE='0.0.0.0'

case "$1" in
  start)
  exec forever --sourceDir=/opt/homebridge -p /var/log/forever start app.js
  ;;

  stop)
  exec forever stop --sourceDir=/opt/homebridge app.js
  ;;
esac

exit 0
EOF
sudo mv /tmp/homebridge-launch-tmp /etc/init.d/homebridge
