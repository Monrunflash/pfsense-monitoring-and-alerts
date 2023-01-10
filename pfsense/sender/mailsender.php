<?php
require "Mail.php";
include "variables.php";

//Current date
$date = exec("date '+%Y/%m/%d at %H:%M:%S'");

// Enter here if the first var is equal to cpu to load the cpu notification
if ($argv[1] == "cpu") {
    $subject = "WARNING: CPU usage" . $argv[2] . "%";
    $body = "It may be an active atack in your firewall.
    Please check if everything it's OK.
    " . $date;
}

// Enter here if the first var is equal to ssh to load the ssh notification
if ($argv[1] == "ssh") {
    $subject = "There is new SSH activity";
    $ssh_connection = exec("cat /tmp/new-connection.log");
    $body = "Here are the new connections:
    " . $ssh_connection;
}

// Enter here if the first var is equal to disk to load the disk notification
if ($argv[1] == "disk") {
    //Folder with disk usage
    $disk_usage = exec("cat /tmp/diskuse.txt | cut -f1 -d\%");
    $subject = "WARNING: Disk Capaticy reach" . $argv[2] . "%";
    $body = "Disk running out of space. 
    Do not forget to check disk space before system crash.
    " . $disk_usage . "
    " . $date;
}

//echo $subject;
//echo $body;

$to      = $receiver; // to email address
$from    = $username; // the email address


$host    = "smtp.gmail.com";
$port    =  "587";
$user    = $username;  // write your mail address
$pass    = $password;  // write your mail password


// Set up the email headers
$headers = array(
    "From" => $from,  // The "From" address
    "To" => $to,      // The "To" address
    "Subject" => $subject  // The subject of the email
  );
  
  // Set up the SMTP server details
  $smtp = @Mail::factory(
    "smtp",  // Use the SMTP protocol
    array(
      "host" => $host,    // The SMTP server hostname
      "port" => $port,    // The SMTP server port
      "auth" => true,     // Use authentication when connecting to the server
      "username" => $user, // The username to use for authentication
      "password" => $pass  // The password to use for authentication
    )
  );
  
  // Send the email
  $mail = @$smtp->send($to, $headers, $body);
  
  // Check if an error occurred
  if (PEAR::isError($mail)) {
    // If an error occurred, echo the error message
    echo "error: {$mail->getMessage()}";
  } else {
    // If the email was sent successfully, echo a message indicating as such
    echo "Message sent";
  }
  
  ?>
  
  
  
  
