#!/bin/sh

# Set the mailfile variable to the path of the temporary file
mailfile="/tmp/email_diskusage.txt"

# Get the disk usage information and store it in the temporary file
df -H > "$mailfile"

# Extract the percentage of disk usage from the second line of the output
percentage_of_usage=$(df -H | sed -n 2p | awk '{print $5}' | cut -d"%" -f1)

# Assign the max disk usage
max_disk_usage=${1:-90}

# If the percentage of disk usage is greater than or equal to the maximum usage
if [ "$percentage_of_usage" -ge "$max_disk_usage" ]; then
  # Then send an email using the mailsender.php script
  echo "Sending email: Disk usage is at $percentage_of_usage% (threshold is $max_usage%)"
  php /root/pfsense/sender/mailsender.php "disk" "$percentage_of_usage"
fi

# Remove the temporary file
rm "$mailfile"