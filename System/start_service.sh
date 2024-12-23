vi /etc/systemd/system/activemq.service

[Unit]
Description=ActiveMQ Message Broker
After=network.target

[Service]
User=<your-username>
Group=<your-group>
ExecStart=/path/to/activemq/bin/activemq start
ExecStop=/path/to/activemq/bin/activemq stop
Restart=always
RestartSec=10
TimeoutSec=300

[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl enable activemq.service
systemctl start activemq.service


systemctl status activemq.service
journalctl -u activemq.service -f
