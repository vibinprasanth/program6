#!/bin/bash

set -u

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="$ROOT_DIR/.mock_bin"

rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

echo "======================================"
echo " Running Linux Firewall Autograder"
echo "======================================"

# ------------------------------------------------
# Mock systemctl
# ------------------------------------------------

cat > "$TEST_DIR/systemctl" <<'EOF'
#!/bin/bash

case "$1 $2" in
    "status firewalld")
        echo "● firewalld.service - firewalld"
        echo "   Active: active (running)"
        exit 0
        ;;

    "start firewalld")
        echo "Mock: firewalld started"
        exit 0
        ;;

    "enable firewalld")
        echo "Mock: firewalld enabled"
        exit 0
        ;;

    *)
        echo "Mock systemctl: unsupported command"
        exit 1
        ;;
esac
EOF

# ------------------------------------------------
# Mock firewall-cmd
# ------------------------------------------------

cat > "$TEST_DIR/firewall-cmd" <<'EOF'
#!/bin/bash

case "$1" in
    --state)
        echo "running"
        exit 0
        ;;

    --get-default-zone)
        echo "public"
        exit 0
        ;;

    --get-active-zones)
        echo "public"
        echo "  interfaces: eth0"
        exit 0
        ;;

    *)
        echo "Mock firewall-cmd: unsupported command"
        exit 1
        ;;
esac
EOF

chmod +x "$TEST_DIR/systemctl"
chmod +x "$TEST_DIR/firewall-cmd"

# ------------------------------------------------
# Static tests
# ------------------------------------------------

bash "$ROOT_DIR/test_cases/test_firewall_check.sh"

STATIC_RESULT=$?

if [ "$STATIC_RESULT" -ne 0 ]; then
    echo
    echo "Static tests failed."
    exit 1
fi

# ------------------------------------------------
# Execute student program using mock commands
# ------------------------------------------------

echo
echo "Executing student script using mocked firewall commands..."

chmod +x "$ROOT_DIR/firewall_check.sh"

PATH="$TEST_DIR:$PATH" \
bash "$ROOT_DIR/firewall_check.sh" > "$ROOT_DIR/student_output.txt" 2>&1

PROGRAM_RESULT=$?

cat "$ROOT_DIR/student_output.txt"

# ------------------------------------------------
# Check exit status
# ------------------------------------------------

if [ "$PROGRAM_RESULT" -eq 0 ]; then
    echo "PASS: Student script exited with status 0"
else
    echo "FAIL: Student script did not exit successfully"
    exit 1
fi

# ------------------------------------------------
# Check expected output
# ------------------------------------------------

OUTPUT="$ROOT_DIR/student_output.txt"

if grep -q "running" "$OUTPUT"; then
    echo "PASS: Firewall state output detected"
else
    echo "FAIL: Firewall state output not detected"
    exit 1
fi

if grep -q "public" "$OUTPUT"; then
    echo "PASS: Default zone output detected"
else
    echo "FAIL: Default zone output not detected"
    exit 1
fi

echo
echo "======================================"
echo " ALL AUTOGRADING TESTS PASSED"
echo "======================================"

exit 0
