#!/bin/sh

# Download and install aa
mkdir /tmp/aa
curl -L -H "Cache-Control: no-cache" -o /tmp/aa/aa.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/aa/aa.zip -d /tmp/aa
install -m 755 /tmp/aa/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/aa/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/aa

# aa new configuration
install -d /usr/local/etc/aa
cat << EOF > /usr/local/etc/aa/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 64
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "ws"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run aa
/usr/local/bin/v2ray -config /usr/local/etc/aa/config.json
