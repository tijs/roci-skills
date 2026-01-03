# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2025-12-29

### Removed

- **backup-state** skill - Replaced by dedicated backup script in parent repo

## [0.3.0] - 2025-12-28

### Added

- **skill-creator** skill - Guide for creating effective skills
- **github-issue** skill - Create and manage GitHub issues in roci-agent
- Agent Skills open standard documentation

## [0.2.0] - 2025-12-27

### Changed

- **Migrated to Agent Skills open standard** - Directory-based skills with
  SKILL.md format
- Skills now use frontmatter for metadata (name, description)
- Compatible with Claude Code, Cursor, and other agents

## [0.1.0] - 2025-12-26

### Added

- Initial skills repository
- **server-version** - Check VPS system info and versions
- **uptime** - Check server uptime and resources
- **service-status** - Check Roci service status
- **deploy** - Deploy and restart services
- **backup-state** - Backup state files (later removed)
- **check-logs** - View service logs
