# TODO | Raketeer

## [Next Release]
- [ ] A task to bump/change the version?
    - Files:
        - *lib/projectname/version.rb*
        - *CHANGELOG.md*
    - Examples:
        - rake 'version[1.0.0-pre]'
        - rake version[1,0,0,pre]
        - rake version[,,+1,]
        - rake version[,,,pre]
        - rake version # Just outputs current version
- [ ] Add RunTask
- [ ] Add ZipTask?
    - ShFileTask or CompressTask as parent?
