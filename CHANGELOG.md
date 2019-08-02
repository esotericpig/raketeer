# Changelog | Raketeer

Format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [[Unreleased]](https://github.com/esotericpig/raketeer/compare/v0.2.5...master)

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
- .gitignore
- CHANGELOG.md
- Gemfile
- LICENSE.txt
- README.md
- Rakefile
- raketeer.gemspec
- lib/raketeer.rb
- lib/raketeer/irb_task.rb
- lib/raketeer/nokogiri_install_tasks.rb
- lib/raketeer/nokogiri_installs.rb
- lib/raketeer/raketeers.rb
- lib/raketeer/version.rb
