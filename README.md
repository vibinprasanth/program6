Linux Firewall – Netfilter, nftables and firewalld
Aim

To study Linux firewall concepts, the Netfilter framework, and the firewalld service by executing and interpreting basic firewall management commands.

Learning Objectives

After completing this assignment, students should be able to:

Explain the role of Netfilter in the Linux kernel.
Explain the relationship between Netfilter, nftables, and firewalld.
Check whether the firewalld service is installed and running.
Start the firewalld service.
Enable firewalld to start automatically at boot.
Check the current firewall state.
Identify the default firewall zone.
Identify the active firewall zones.
Write a Bash script to automate firewall checks.
Theory
Netfilter

Netfilter is a kernel-level framework in Linux that provides packet filtering, packet modification, and other network-related operations.

nftables

nftables is the modern packet-filtering framework used in Linux and is the successor to the traditional iptables framework.

firewalld

firewalld is a dynamic firewall management service that provides a higher-level interface for configuring firewall rules and zones.

The relationship can be summarized as:

User
  |
  v
firewalld
  |
  v
nftables
  |
  v
Netfilter
  |
  v
Linux Kernel

Commands to Study

The following commands are part of this practical:

systemctl status firewalld
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --state
firewall-cmd --get-default-zone
firewall-cmd --get-active-zones

Student Task

Create a Bash script named:

firewall_check.sh


The script must perform the following checks.

Requirement 1 – Check firewalld service

Use:

systemctl status firewalld


The script should report whether the firewalld service is active.

Expected output should contain a meaningful message such as:

firewalld service is active


or

firewalld service is not active

Requirement 2 – Start firewalld

Use:

systemctl start firewalld


The script should attempt to start the service when it is not running.

Your script must handle command failure gracefully.

Requirement 3 – Enable firewalld

Use:

systemctl enable firewalld


The script should attempt to enable firewalld at system startup.

Requirement 4 – Check firewall state

Use:

firewall-cmd --state


The script should display the firewall state.

Typical output:

running

Requirement 5 – Display default zone

Use:

firewall-cmd --get-default-zone


The script should display the default firewall zone.

For example:

public

Requirement 6 – Display active zones

Use:

firewall-cmd --get-active-zones


The script should display the active firewall zones.

Required Script Behavior

Your script must:

Be written in Bash.
Start with a Bash shebang.
Use the required Linux commands.
Display clear messages for each operation.
Handle command failures without abruptly terminating.
Exit with status 0 when the script completes successfully.
Be executable.

The first line should be:

#!/bin/bash

Important Safety Requirement

Do not add commands that flush, delete, or permanently modify firewall rules.

Do NOT use commands such as:

iptables -F
nft flush ruleset
firewall-cmd --complete-reload


Only perform the operations required by this assignment.

Testing Locally

Make the script executable:

chmod +x firewall_check.sh


Run:

./firewall_check.sh


Check the exit status:

echo $?

Submission

Push the following files to your GitHub repository:

firewall_check.sh
README.md


The GitHub Actions workflow will automatically test your submission.

Submission Checklist

Before submitting, verify:

 firewall_check.sh exists.
 The script starts with #!/bin/bash.
 The script contains systemctl status firewalld.
 The script contains systemctl start firewalld.
 The script contains systemctl enable firewalld.
 The script contains firewall-cmd --state.
 The script contains firewall-cmd --get-default-zone.
 The script contains firewall-cmd --get-active-zones.
 The script is executable.
 The script exits successfully.
 No destructive firewall commands have been added.
Academic Integrity

Write your own Bash script. You may refer to Linux documentation and course materials, but do not copy another student's complete solution.

Expected Learning Outcome

Students should be able to explain the Linux firewall architecture and automate basic firewalld status and configuration checks using Bash.
