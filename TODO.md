# TODO | Raketeer

## [v1.0.0]
- [x] A task to bump/change the version?
    - Files:
        - lib/projectname/version.rb
        - CHANGELOG.md
        - Gemfile.lock
- [x] Add RunTask
- [ ] Add ZipTask? compress_tasks?
    - ShFileTask or CompressTask as parent?
    - [ ] Add GzipTask using zlib?
    - [ ] Add RubyZipTask using rubyzip?
- [ ] Task to output Gemspec files?
- [ ] Add *check_env()* to IRBTask & RunTask for `warn=true`?
- [ ] Task for `grep todo\: -ir ./` & `grep fixme\: -ir ./` so don't have to type it all of the time?
    - Don't use `sh 'grep',...`; use Ruby code (`Dir.glob...`)
    - Default to ignore hidden dirs/files (e.g., '.git/')
        - `files.exclude('.git/','*/**/TODO*')`
- [ ] Task for changing GPL/LGPL license header text, changing LICENSE.txt, and for changing the project name in the license header text (for GPL/LGPL).
