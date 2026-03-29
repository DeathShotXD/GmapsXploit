![Logo](logo.png)

[![GitHub stars](https://img.shields.io/github/stars/DeathShotXD/GmapsXploit?style=social)](https://github.com/DeathShotXD/GmapsXploit/stargazers)
[![GitHub license](https://img.shields.io/github/license/DeathShotXD/GmapsXploit)](LICENSE)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D4.0-green)]()

# GmapsXploit - Ultimate Google API Key Auditor

GmapsXploit is an open-source tool built for bug bounty hunters to turn exposed or unrestricted Google API keys into high-impact findings.

It audits Google API keys across multiple services such as Maps, Places, Roads, Gemini, Firebase, Vision and more, and helps demonstrate real risks like data exposure and billing abuse.

Instead of reporting low severity issues, this tool helps you show clear impact with actual cost calculations and ready-to-use reports.

## Why use GmapsXploit

- Covers more than 30 Google Cloud endpoints including Maps, Places, Roads and newer APIs
- Calculates financial impact based on request volume
- Detects API key restrictions such as IP or referer limits
- Generates a ready-to-submit Markdown report for bug bounty platforms
- Clean terminal output with no external dependencies
- Useful for escalating API key exposure from low to critical severity

## Key Features

### Core APIs tested
- Static Maps
- Street View
- Geocoding
- Directions
- Distance Matrix
- Elevation
- Timezone

### Places API
- Nearby Search
- Text Search
- Find Place
- Autocomplete
- Place Details
- Photos

### Roads API
- Nearest Roads
- Snap to Roads
- Speed Limits

### Other APIs
- Air Quality
- Pollen Forecast
- Routes API
- Aerial View API

### Cloud services
- Gemini Generative Language
- Cloud Vision
- Translation API
- Custom Search
- Geolocation API
- Firebase Dynamic Links
- Address Validation

## Features in action

- Shows vulnerability status in real time
- Displays financial impact per 100k requests
- Generates two reports automatically
- Optional request simulation for proof of impact

## Installation

```bash
git clone https://github.com/DeathShotXD/GmapsXploit.git
cd GmapsXploit
chmod +x GmapsXploit.sh
./GmapsXploit.sh
```

## Usage

Run the script:

```bash
./GmapsXploit.sh
```

Steps:

1. Enter the target Google API key
2. Observe the reconnaissance phase
3. Review the financial impact results
4. Use the generated report for submission

## Output files

Each run generates:

- gmapsxploit_report_*.txt  
  Contains full technical details

- bounty_report_*.md  
  Ready to submit report for bug bounty platforms
  
## Example Output

![Demo Output](demo.png)


| Endpoint Tested | Status      |
|-----------------|-------------|
| Static Maps     | VULNERABLE  |
| Places Nearby   | VULNERABLE  |

Generated report: `gmapsxploit_report_1774767832.txt`

## Real world impact

Unrestricted Google API keys, especially those with Places or advanced APIs enabled, can lead to serious billing abuse.

There have been cases where costs reached tens of thousands of dollars within a short time.

This tool helps you demonstrate that impact clearly with real numbers and working proof.

## Who should use this

- Bug bounty hunters looking for high impact findings
- Penetration testers auditing cloud configurations
- Security researchers analyzing exposed API keys in web apps, mobile apps or extensions

## Credits

Author: D34thSh0tX_X  
GitHub: [https://github.com/DeathShotXD](https://github.com/DeathShotXD)  
Project: GmapsXploit

If you find this tool useful, consider starring the repository.

## License

MIT License
