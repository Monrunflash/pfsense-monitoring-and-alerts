# Monitoring with grafana and automatice with shell script notifications alerts

This project is designed to enhance the monitoring and automation capabilities of a pfSense firewall. By using Docker containers, the project sets up a suite of services that can continuously monitor the performance and status of the firewall. In the event that any issues are detected, the project includes scripts that can automatically identify the problem and generate notifications to alert the appropriate parties. This ensures that any problems with the firewall are detected and resolved as quickly as possible, minimizing downtime and ensuring the smooth operation of the network.


## Deploying containers with Docker Compose

Before deploying, it's important to have an understanding of the architecture. First, an InfluxDB database is needed to store the series of data from the pfSense firewall, which is collected by the Telegraf agent. After this, a Grafana instance is deployed, which depends on the InfluxDB database. In this example, we will be binding the InfluxDB and the Grafana database to a local directory to store all the data locally. However, in a production environment, it is recommended to have a shared NFS volume in a highly available setup and to mount the data on the system for safekeeping.

First of all create the directories to store the data. 

`mkdir grafana-storage`
`mkdir influx-storage`

To deploy the docker-compose.yml, which is a configuration file, you can use the following methods:

- Running the compose file with active logs:
```
sudo docker-compose up
```

- Running the compose file in the background, allowing you to close the terminal, and automatically restarting after a reboot:
```
sudo docker-compose up -d --restart=always
```

- Background execution with the capability of closing the terminal and after a reboot an automatic rebuild
```
sudo docker-compose up -d --restart=always
```

It is important to note that using `sudo` is only necessary if you are running the command as a non-root user.

## Monitoring the OS with Shell scripting and Sending Notification Alerts with PHP

PfSense includes some scripts that allow you to monitor new SSH connections, disk usage, and the CPU state. If these values exceed a certain threshold, a PHP script will be executed that sends you an email notification.

To set this up, you need to:

- Copy the folder to the `/root/` directory
- Configure the `variables.php` file by adding your email account information and an application token for SMTP authentication (otherwise the Google SMTP server will reject the connection)
- Edit the `/etc/crontab` file and add the scheduled task

Once set up, these tasks will run automatically, and if you want to add more tasks, you only need to add the conditions to the mailsender.php file and create the appropriate scripts.
 

