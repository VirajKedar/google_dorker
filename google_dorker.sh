#!/usr/bin/env bash
#
# Google Dork Launcher
# A simple Bash utility that allows you to launch Google Dorks directly
# from your Linux terminal. Designed for penetration testers and researchers.
#
# Author: Your Name
# Repository: https://github.com/yourusername/google-dork-launcher
# License: MIT
#
# ---------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2025 Your Name
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ---------------------------------------------------------------------------


# ---------------------------
# Colors
# ---------------------------
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

VERSION="1.0.0"


# ---------------------------
# URL Encoder
# ---------------------------
urlencode() {
    local LANG=C
    local encoded=""
    local c

    for ((i = 0; i < ${#1}; i++)); do
        c=${1:$i:1}
        case $c in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            *) encoded+=$(printf '%%%02X' "'$c") ;;
        esac
    done

    printf '%s' "$encoded"
}


# ---------------------------
# Help menu
# ---------------------------
show_help() {
    echo -e "${CYAN}Google Dork Launcher v$VERSION${RESET}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -q, --query \"QUERY\"   Launch a Google Dork directly"
    echo "  -h, --help             Show this help message"
    echo "  -v, --version          Show version information"
    echo ""
    echo "Examples:"
    echo "  $0 --query \"site:edu filetype:pdf password\""
    echo ""
}


# ---------------------------
# Version info
# ---------------------------
show_version() {
    echo "Google Dork Launcher v$VERSION"
}


# ---------------------------
# Main Execution
# ---------------------------

# Check if xdg-open exists
if ! command -v xdg-open &> /dev/null; then
    echo -e "${RED}[ERROR] xdg-open is not installed. Install it to continue.${RESET}"
    exit 1
fi


# Parse flags
if [[ $# -gt 0 ]]; then
    case "$1" in
        -h|--help) show_help; exit 0 ;;
        -v|--version) show_version; exit 0 ;;
        -q|--query)
            shift
            DORK_QUERY="$*"
            ;;
        *)
            echo -e "${RED}[ERROR] Unknown option: $1${RESET}"
            exit 1
            ;;
    esac
else
    # Ask user for input interactively
    echo -e "${YELLOW}Enter your Google Dork query:${RESET}"
    read -r DORK_QUERY
fi


# Must not be empty
if [[ -z "$DORK_QUERY" ]]; then
    echo -e "${RED}[ERROR] Query cannot be empty.${RESET}"
    exit 1
fi

# Encode and open
ENCODED_QUERY=$(urlencode "$DORK_QUERY")
GOOGLE_URL="https://www.google.com/search?q=$ENCODED_QUERY"

echo -e "${GREEN}[OK] Opening:${RESET} $GOOGLE_URL"
xdg-open "$GOOGLE_URL" >/dev/null 2>&1 &

exit 0
