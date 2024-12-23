# ActiveMQ Systemd Service Setup

This guide explains how to configure ActiveMQ to start automatically on boot and restart if it stops.

## Steps

### 1. Create Service File
1. Open a terminal and run:
   ```bash
   sudo nano /etc/systemd/system/activemq.service
   ```
2. Add the following:
   ```ini
   [Unit]
   Description=ActiveMQ Message Broker
   After=network.target

   [Service]
   User=<your-username>
   ExecStart=/path/to/activemq/bin/activemq start
   ExecStop=/path/to/activemq/bin/activemq stop
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```
   Replace `<your-username>` and `/path/to/activemq` as needed.

### 2. Enable and Start Service
1. Reload systemd:
   ```bash
   sudo systemctl daemon-reload
   ```
2. Enable the service to start on boot:
   ```bash
   sudo systemctl enable activemq.service
   ```
3. Start the service:
   ```bash
   sudo systemctl start activemq.service
   ```

### 3. Verify Service
Check service status:
```bash
sudo systemctl status activemq.service
```

### 4. Monitor Logs
To view logs:
```bash
journalctl -u activemq.service -f
```

