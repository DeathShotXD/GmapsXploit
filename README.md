# GmapsXploit

GmapsXploit audits exposed or unrestricted Google API keys and turns them
into high-impact findings. It tests a key against Google Maps, Places, Roads,
the newer Routes and Aerial View endpoints, and several Cloud services, then
shows the real risk: what the key can reach and what it costs. Instead of a
low severity note, you get a clear impact and a ready-to-submit report.

<p align="center">
  <img src="logo.png" alt="GmapsXploit" width="340">
</p>

<br>

## What is GmapsXploit?

It is a single Bash script for bug bounty hunters, penetration testers, and
researchers who find Google API keys in web apps, mobile apps, or extensions.
It probes the key across more than thirty endpoints, detects restrictions such
as IP or referer limits, estimates billing impact from request volume, and
writes a Markdown report suitable for a program.

<br>

> An exposed Google API key is not a low finding when it is unrestricted and
> bills someone else's account.

## Why this matters

Unrestricted Google API keys, especially with Places or the advanced APIs
enabled, allow anyone to run up a bill on the owner's account. There are
public cases where costs reached tens of thousands of dollars in a short
time. GmapsXploit shows that impact with real numbers and a working proof.

## Coverage

- Core Maps: Static Maps, Street View, Geocoding, Directions, Distance Matrix,
  Elevation, Timezone.
- Places: Nearby Search, Text Search, Find Place, Autocomplete, Place Details,
  Photos.
- Roads: Nearest Roads, Snap to Roads, Speed Limits.
- Other: Air Quality, Pollen Forecast, Routes, Aerial View.
- Cloud services: Gemini, Cloud Vision, Translation, Custom Search,
  Geolocation, Firebase Dynamic Links, Address Validation.

## Features

- Tests more than thirty Google Cloud endpoints in one pass.
- Calculates financial impact from request volume.
- Detects key restrictions such as IP or referer limits.
- Generates a ready-to-submit Markdown report.
- Clean terminal output with no external dependencies.
- Helps escalate API key exposure from low to critical severity.

## Installation

```bash
git clone https://github.com/DeathShotXD/GmapsXploit.git
cd GmapsXploit
chmod +x GmapsXploit.sh
./GmapsXploit.sh
```

Bash 4.0 or later. No external dependencies.

## Usage

```bash
./GmapsXploit.sh
```

1. Enter the target Google API key.
2. Watch the reconnaissance phase.
3. Review the financial impact results.
4. Use the generated report for submission.

## Output

Each run writes two files:

- `gmapsxploit_report_*.txt` - the full technical detail.
- `bounty_report_*.md` - a submission-ready report.

## Example

![Demo output](demo.png)

| Endpoint tested | Status |
|-----------------|--------|
| Static Maps | VULNERABLE |
| Places Nearby | VULNERABLE |

Generated report: `gmapsxploit_report_1774767832.txt`.

A sample report is in
[examples/gmapsxploit_report_sample.txt](examples/gmapsxploit_report_sample.txt).

## Detection and defensive guidance

Indicators of exposure to look for:

- API keys present in client-side code, bundles, or app packages.
- Requests to Google API hosts from unexpected sources.
- Billing spikes without a matching deployment.

Mitigations:

- Restrict every key by application, IP, referer, or API.
- Keep keys server-side and out of client bundles.
- Enable budget alerts and quotas per key.
- Rotate any key that has been public.

## Repository structure

```
GmapsXploit/
|-- GmapsXploit.sh
|-- report_template.md
|-- README.md
|-- LICENSE
|-- SECURITY.md
|-- CHANGELOG.md
|-- CONTRIBUTING.md
|-- PLAN.md
|-- logo.png
|-- demo.png
|-- examples/
|   +-- gmapsxploit_report_sample.txt
+-- tests/
    +-- smoke.sh
```

## Limitations

- Impact is estimated from published pricing and request volume; Google may
  cap or bill differently.
- A restricted key can still be valid; the tool reports the restriction.
- Coverage tracks the public endpoints at the time of release.

## References

- Google Maps Platform API security best practices.
- Google Maps Platform pricing.

## Responsible use

GmapsXploit is built for authorized security testing. Run it only against
keys and accounts you own or have explicit permission to test. Using it
against systems without authorization may violate law.

## Credits

Author: D34thSh0tX_X (github.com/DeathShotXD).

## License

MIT. See [LICENSE](LICENSE).
