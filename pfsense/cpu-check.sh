#!/bin/sh

# Function to calculate CPU usage
calc_cpu() {
    # Get the CPU usage
    cpu_usage=$(vmstat 1 2 | tail -1 | sed 's/ \{1,\}/ /g' | awk '{print $19}')
    cpu_usage=$((100 - $cpu_usage))
    # Return the CPU usage percentage
    echo "$cpu_usage"
}

# Set the threshold for CPU usage to 90% by default
cpu_threshold=${1:-90}


# Initialize the check counter
check_count=0

# Set the maximum number of times to check the CPU usage
max_checks=6

# Set the number of seconds to sleep between checks
sleep_seconds=5

#Set the first CPU usage
cpu_usage=$(calc_cpu)

echo "First check $cpu_usage% usage"

# Loop until the CPU usage falls below the threshold or the maximum number of checks has been reached
while [ "$cpu_usage" -ge "$cpu_threshold" ] && [ "$check_count" -lt "$max_checks" ]; do
    # Increment the check counter
    check_count=$((check_count + 1))

    # Calculate the CPU usage
    cpu_usage=$(calc_cpu)
    
    echo "$cpu_usage% usage, $check_count lap"
    # If the CPU usage is above the threshold, sleep for a few seconds
    if [ "$cpu_usage" -ge "$cpu_threshold" ]; then
        sleep "$sleep_seconds"
    fi
done

# If the CPU usage falls below the threshold, exit
if [ "$cpu_usage" -lt "$cpu_threshold" ]; then
    exit
fi

# If the maximum number of checks has been reached, run the PHP script
if [ "$check_count" -eq "$max_checks" ]; then
    # Run the PHP script
    echo "sending"
    php /root/sender/mailsender.php "cpu" "$cpu_usage"
fi