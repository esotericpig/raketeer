# TODO | Raketeer

## [v0.3]
- [ ] A task to bump/change the version?
    - Files:
        - lib/projectname/version.rb
        - CHANGELOG.md
        - Gemfile.lock
    - Examples:
        - rake 'version[1.0.0-pre]'
        - rake version[1,0,0,pre]
        - rake version[,,+1,]
        - rake version[,,,pre]
        - rake version # Just outputs current version
- [x] Add RunTask
- [ ] Add ZipTask?
    - ShFileTask or CompressTask as parent?
    - [ ] Add GzipTask using zlib?
    - [ ] Add RubyZipTask using rubyzip?
