# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Update default k6 version to `0.36.0`

## [0.1.0] - 2021-01-07

### Added

- Add `setInterval` and `setTimeout` to utilities for Phoenix Channels and Liveview

### Changed

- Update default k6 version to `0.35.0`
- Check local k6 binary is at correct version before running it
- Add check for http status once websocket is established
- No longer try to infer port and host from Phoenix app

### Fixed

- Fix retrieval of CSRF token for Liveview
- In `k6` task, always return same exit code as k6
