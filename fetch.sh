cd ~/doc/config
#clone new repo to temp location, try ssh first so if key exists u can push
(git clone git@github.com:zaid-g/config.git config.new || git clone https://github.com/zaid-g/config.git config.new) && rm -rf config && mv config.new config
