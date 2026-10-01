# Changelog

Notable changes to GmapsXploit, newest first.

## Unreleased

### Changed

- Rewrote the README in plain ASCII with the project layout used across the
  repository set.
- Reworked the script with argument parsing, help, and version output.

### Added

- Command line options for the key, output directory, timeout, simulation,
  count, color, and quiet output.
- Both a text report and a Markdown report per run.
- Continuous integration and a smoke test.
- Security policy, contributing guide, maintenance plan, and templates.

## 1.0.0

### Added

- Audits a Google API key across Maps, Places, Roads, Routes, Aerial View,
  and several Cloud services.
- Detects key restrictions such as referer and IP limits.
- Estimates billing impact per 1000 requests.
- Optional opt-in billing simulation.
