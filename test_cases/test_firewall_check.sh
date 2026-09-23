#!/bin/bash

SCRIPT="./firewall_check.sh"

PASS=0
FAIL=0

test_pass() {
    echo "PASS: $1"
    PASS=$((PASS + 1))
}

test_fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
}

# TC01 - File exists
if [ -f "$SCRIPT" ]; then
    test_pass "firewall_check.sh exists"
else
    test_fail "firewall_check.sh does not exist"
fi

# TC02 - Bash shebang
if head -n 1 "$SCRIPT" | grep -q "#!/bin/bash"; then
    test_pass "Bash shebang found"
else
    test_fail "Bash shebang missing"
fi

# TC03 - systemctl status firewalld
if grep -Eq 'systemctl[[:space:]]+status[[:space:]]+firewalld' "$SCRIPT"; then
    test_pass "systemctl status firewalld found"
else
    test_fail "systemctl status firewalld missing"
fi

# TC04 - systemctl start firewalld
if grep -Eq 'systemctl[[:space:]]+start[[:space:]]+firewalld' "$SCRIPT"; then
    test_pass "systemctl start firewalld found"
else
    test_fail "systemctl start firewalld missing"
fi

# TC05 - systemctl enable firewalld
if grep -Eq 'systemctl[[:space:]]+enable[[:space:]]+firewalld' "$SCRIPT"; then
    test_pass "systemctl enable firewalld found"
else
    test_fail "systemctl enable firewalld missing"
fi

# TC06 - firewall-cmd --state
if grep -Eq 'firewall-cmd[[:space:]]+--state' "$SCRIPT"; then
    test_pass "firewall-cmd --state found"
else
    test_fail "firewall-cmd --state missing"
fi

# TC07 - default zone
if grep -Eq 'firewall-cmd[[:space:]]+--get-default-zone' "$SCRIPT"; then
    test_pass "firewall-cmd --get-default-zone found"
else
    test_fail "firewall-cmd --get-default-zone missing"
fi

# TC08 - active zones
if grep -Eq 'firewall-cmd[[:space:]]+--get-active-zones' "$SCRIPT"; then
    test_pass "firewall-cmd --get-active-zones found"
else
    test_fail "firewall-cmd --get-active-zones missing"
fi

# TC09 - Bash syntax
if bash -n "$SCRIPT"; then
    test_pass "Bash syntax is valid"
else
    test_fail "Bash syntax error"
fi

# TC10 - No destructive commands
if grep -Eq \
'iptables[[:space:]]+-F|nft[[:space:]]+flush[[:space:]]+ruleset|firewall-cmd[[:space:]]+--complete-reload' \
"$SCRIPT"; then
    test_fail "Destructive firewall command found"
else
    test_pass "No destructive firewall command found"
fi

echo
echo "=============================="
echo "Tests Passed: $PASS"
echo "Tests Failed: $FAIL"
echo "=============================="

if [ "$FAIL" -eq 0 ]; then
    exit 0
else
    exit 1
fi

