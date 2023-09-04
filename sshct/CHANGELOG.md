
# Change Log

## [4.0.0] - 2023-09-04

### Added

- CHANGELOG file

### Changed

- Base image changed from Ubuntu 20.04 to 22.04
- Default timezone changed from Asia/Novosibirsk to UTC
- All environment variables are starting from `CT_`
- Environment variables defaults are moved to entrypoint script
- nodeJS upgraded to 18
- MongoDB tools upgraded to 7.0
- Removed repo for buildah (it's in official repos now)
- tmux is used as login shell

### Fixed

- Added missing tzdata
- CT_USERPUBKEY is added only once
