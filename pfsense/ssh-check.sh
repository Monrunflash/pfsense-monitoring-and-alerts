#!/bin/sh

# create a temporal copy of the file to check the diferences 
copy_auth_log(){
    cat /var/log/auth.log > /tmp/auth.log
}

calc_hash() {
  # Calculate the SHA-256 hash of the file and keep only the hash value (cut out the file name)
  sha256sum /tmp/auth.log | cut -d" " -f1
}

calc_new_hash() {
  # Calculate the SHA-256 hash of the file and keep only the hash value (cut out the file name)
  sha256sum /var/log/auth.log | cut -d" " -f1
}

create_new_connections_log(){
    diff /var/log/auth.log /tmp/auth.log | grep "^<" > /tmp/new-connection.log
    copy_auth_log
}

# Read the original hash of the auth.log file
copy_auth_log
checked_hash=$(calc_hash)
echo "Original hash: $checked_hash"

# This script will run indefinitely in a loop
while true; do

  # Wait for a minute
  sleep 60

  # Calculate the new hash of the auth.log file
  # and store it in the "new_hash" variable
  new_hash=$(calc_new_hash)
  echo "New hash: $new_hash"

  # If the new hash is different from the original hash,
  # run the following code block
  if [ "$new_hash" != "$checked_hash" ]; then

    # Create a new log file containing the new log lines
    create_new_connections_log

    # Update the "checked_hash" variable with the new hash value
    checked_hash=$(calc_hash)

    # Send an email with the new log lines using the "mailsender.php" script
    echo "Sending email with new log lines"
    php /root/sender/mailsender.php "ssh" "ssh"

    # Wait 10 seconds before deleting the new log file
    sleep 10

    # Delete the new log file
    rm /tmp/new-connection.log
  fi
done