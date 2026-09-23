#!/bin/bash

# Linux Firewall Practical
# Student Name:
# Register Number:

# 1. Check firewalld service status
systemctl status firewalld

# 2. Start firewalld
# TODO: Complete the command
systemctl start firewalld

# 3. Enable firewalld at boot
# TODO: Complete the command
systemctl enable firewalld

# 4. Check firewall state
# TODO: Complete the command
firewall-cmd --state

# 5. Get default firewall zone
# TODO: Complete the command
firewall-cmd --get-default-zone

# 6. Get active firewall zones
# TODO: Complete the command
firewall-cmd --get-active-zones
