# Changelog | Raketeer

Format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [[Unreleased]](https://github.com/esotericpig/raketeer/compare/v0.2.2...master)

## [v0.2.2] - 2019-07-29
### Changed
- Refactored some code (minor)
- Changed some documentation (minor)

### Added
- RunTask & 'raketeer/run'
- Util
- bin/raketeer (for testing purposes only, not included in the Gem package)

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
