# Changelog | Raketeer

All notable changes to this project will be documented in this file.

Format is based on [Keep a Changelog v1.0.0](https://keepachangelog.com/en/1.0.0),
and this project adheres to [Semantic Versioning v2.0.0](https://semver.org/spec/v2.0.0.html).

## [[Unreleased]](https://github.com/esotericpig/raketeer/compare/v0.2.13...HEAD)
-


## [v0.2.13] - [2021-06-22](https://github.com/esotericpig/raketeer/compare/v0.2.12...v0.2.13)
### Fixed
- Changed `bump` to reset lower version numbers.
    - If `v1.1.1`, major +1 will become => `v2.0.0` (not `v2.1.1`).
    - If `v1.1.1`, minor +1 will become => `v1.2.0` (not `v1.2.1`).
    - Patch +1 will continue to work the same.
    - It's debatable whether this is a *fix* or a *change*, but I'm labeling it as a *fix*, as this way is more usable and expected.
    - I debated whether to also drop off the pre-release and build-metadata, but it's a hard decision. Even though the version changed, maybe it's still a pre-release and/or still needs the same build-metadata. You could argue that bumping the major version should always drop it off, but I'm not sure. For now, they are unaffected by this change. In the future, major (only) +1 might also drop pre-release & build-metadata.


## [v0.2.12] - [2021-06-18](https://github.com/esotericpig/raketeer/compare/v0.2.11...v0.2.12)
### Changed
- Changed `bump` to also update GitHub compare links in Changelogs.
    - Example link in Changelog:
        - `## [v0.2.11] - [2021-06-15](https://github.com/esotericpig/raketeer/compare/v0.2.10...v0.2.11)`
    - Updates `v0.2.10...v0.2.11` to `v0.2.11...<new_version>`.


## [v0.2.11] - [2021-06-15](https://github.com/esotericpig/raketeer/compare/v0.2.10...v0.2.11)
### Changed
- Added SPDX license ID to source files.


## [v0.2.10] - 2021-05-30
### Changed
- Formatted all code using RuboCop.

### Fixed
- Updated Bundler and Gems because of GitHub security warning.


## [v0.2.9] - 2020-03-01
### Changed
- Changed Gemspec description (mainly for testing other project Raketary)


## [v0.2.8] - 2020-03-01
### Added
- GitHubPkg (lib/raketeer/github_pkg.rb)
- GitHubPkgTask (lib/raketeer/github_pkg_task.rb)
    - Publish/Push your `pkg/*.gem` release(s) to GitHub Packages


## [v0.2.7] - 2019-12-18
### Added
- Add more info to README
- Add default dirs to Util methods
- Add Util.get_env_bool() method
- Add more TODOs and skeletons for future
- Add strict as an env var to bump task

### Fixed
- Check env vars for bundle task in bump task


## [v0.2.6] - 2019-08-03
### Changed
- Refactored BumpTask for a new project I'm working on to use this project in a CLI

### Fixed
- SemVer's initialize_copy()


## [v0.2.5] - 2019-08-02
### Added
- Added a strict mode (regex) to BumpTask, BumpVer, FilesBumper, & SemVer

### Fixed
- Fixed the 'Nothing written (up-to-date)' feature in BumpTask (minor)


## [v0.2.4] - 2019-08-02
### Added
- BumpTask & 'raketeer/bump'
- FilesBumper (lib/raketeer/files_bumper.rb)
- SemVer (lib/raketeer/sem_ver.rb)
- BumpVer (lib/raketeer/bump_ver.rb)
- To Util:
    - to_bool() & TRUE_BOOLS (from my yard_ghurt project)
- To version.rb:
    - DEP_VERSIONS & try_require_dev() (for future use)

### Changed
- Util.find_main_executable() to not search for 'bin/*.rb' since almost no project uses an extension in the bin directory


## [v0.2.3] - 2019-07-30
### Fixed
- Fixed 'yield' typo in some tasks


## [v0.2.2] - 2019-07-29
### Added
- RunTask & 'raketeer/run'
- Util
- bin/raketeer (for testing purposes only, not included in the Gem package)

### Changed
- Refactored some code (minor)
- Changed some documentation (minor)


## [v0.2.1] - 2019-07-24
### Changed
- Fixed minor/cosmetic typo


## [v0.2.0] - 2019-07-24
### Added
- All (lib/raketeer/all.rb); used to be Raketeers
    - `require 'raketeer/all'`
- IRB (lib/raketeer/irb.rb)
    - `require 'raketeer/irb'`

### Removed
- Raketeers (lib/raketeer/raketeers.rb); renamed to All


## [v0.1.0] - 2019-07-23
### Added
- IRB task
- Nokogiri installs
