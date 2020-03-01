# Raketeer

[![Gem Version](https://badge.fury.io/rb/raketeer.svg)](https://badge.fury.io/rb/raketeer)

[![Source Code](https://img.shields.io/badge/source-github-%23A0522D.svg?style=for-the-badge)](https://github.com/esotericpig/raketeer)
[![Changelog](https://img.shields.io/badge/changelog-md-%23A0522D.svg?style=for-the-badge)](CHANGELOG.md)
[![License](https://img.shields.io/github/license/esotericpig/raketeer.svg?color=%23A0522D&style=for-the-badge)](LICENSE.txt)

Extra Ruby Rake Tasks.

A [CLI app](https://github.com/esotericpig/raketary) is also available that uses these tasks, which is useful for tasks like *bump* (which bumps the version for your RubyGem project) so that you don't have to include this Gem as a development dependency for every project.

## Contents

- [Setup](#setup)
- [Using](#using)
- [Hacking](#hacking)
- [License](#license)

## [Setup](#contents)

Pick your poison...

With the RubyGems CLI package manager:

`$ gem install raketeer`

In your *Gemspec* (*&lt;project&gt;.gemspec*):

```Ruby
spec.add_development_dependency 'raketeer', '~> X.X.X'
```

In your *Gemfile*:

```Ruby
gem 'raketeer', '~> X.X.X', :group => [:development, :test]
# or...
gem 'raketeer', :git => 'https://github.com/esotericpig/raketeer.git',
                :tag => 'vX.X.X', :group => [:development, :test]
```

Manually:

```
$ git clone 'https://github.com/esotericpig/raketeer.git'
$ cd raketeer
$ bundle install
$ bundle exec rake install:local
```

## [Using](#contents)

**TODO:** flesh out Using section

**Rakefile**

In your *Rakefile*, you can either include all tasks...

```Ruby
require 'raketeer/all'
```

Or, include the specific tasks that you need:

```Ruby
require 'raketeer/bump'
require 'raketeer/github_pkg'
require 'raketeer/irb'
require 'raketeer/nokogiri_installs'
require 'raketeer/run'
```

If you have conflicting tasks and/or you want to see what tasks have been included, you can put them in a namespace:

```Ruby
namespace :rt do
  require 'raketeer/all'
end
```

**Included Tasks**

```
rake bump[version]      # Show/Set/Bump the version
rake bump:build[build]  # Set/Erase the build metadata
rake bump:bundle        # Bump the Gemfile.lock version
rake bump:help          # Show the help/usage for bump tasks
rake bump:major[major]  # Bump/Set the major version
rake bump:minor[minor]  # Bump/Set the minor version
rake bump:patch[patch]  # Bump/Set the patch version
rake bump:pre[pre]      # Set/Erase the pre-release version
rake github_pkg         # Publish this project's gem(s) to GitHub Packages
rake irb                # Open an irb session loaded with this library
rake nokogiri_apt       # Install Nokogiri libs for Ubuntu/Debian
rake nokogiri_dnf       # Install Nokogiri libs for Fedora/CentOS/Red Hat
rake nokogiri_other     # Install Nokogiri libs for other OSes
rake run                # Run this project's main file: "rake run -- --version"
```

**bump:help**

```
$ rake bump:help
rake bump  # Print the current version

# You can run a dry run for any task (will not write to files)
rake bump dryrun=true

rake bump[1.2.3-alpha.4-beta.5]       # Set the version manually
rake bump major=1 minor=2 patch=3     # Set the version numbers
rake bump pre=alpha.4 build=beta.5    # Set the version extensions
rake bump major=+1 minor=+1 patch=+1  # Bump the version numbers by 1
rake bump major=+2 minor=+3 patch=+4  # Bump the version numbers by X

rake bump:major          # Bump the major version by 1
rake bump:major[1]       # Set the major version to 1
rake bump:major[+2]      # Bump the major version by 2
rake bump:minor          # Bump the minor version by 1
rake bump:minor[2]       # Set the minor version to 2
rake bump:minor[+3]      # Bump the minor version by 3
rake bump:patch          # Bump the patch version by 1
rake bump:patch[3]       # Set the patch version to 3
rake bump:patch[+4]      # Bump the patch version by 4
rake bump:pre            # Erase the pre-release version
rake bump:pre[alpha.4]   # Set the pre-release version
rake bump:build          # Erase the build metadata
rake bump:build[beta.5]  # Set the build metadata
rake bump:bundle         # Bump the Gemfile.lock version
```

**Modifying Tasks**

If you need more control, for now, please look at the accessors of each task (better documentation is planned for v1.0.0):

- [BumpTask](lib/raketeer/bump_task.rb)
- [GitHubPkgTask](lib/raketeer/github_pkg_task.rb)
- [IRBTask](lib/raketeer/irb_task.rb)
- [NokogiriAPTTask](lib/raketeer/nokogiri_install_tasks.rb)
- [NokogiriDNFTask](lib/raketeer/nokogiri_install_tasks.rb)
- [NokogiriOtherTask](lib/raketeer/nokogiri_install_tasks.rb)
- [RunTask](lib/raketeer/run_task.rb)

For example, in your *Rakefile*:

```Ruby
require 'raketeer/bump_task'

Raketeer::BumpTask.new() do |task|
  task.strict = true
end

require 'raketeer/github_pkg_task'

Raketeer::GitHubPkgTask.new() do |task|
  task.deps << 'test'
  task.username = 'esotericpig'
end
```

## [Hacking](#contents)

```
$ git clone 'https://github.com/esotericpig/raketeer.git'
$ cd raketeer
$ bundle install
$ bundle exec rake -T
```

## [License](#contents)

[GNU LGPL v3+](LICENSE.txt)

> Raketeer (<https://github.com/esotericpig/raketeer>)  
> Copyright (c) 2019-2020 Jonathan Bradley Whited (@esotericpig)  
> 
> Raketeer is free software: you can redistribute it and/or modify  
> it under the terms of the GNU Lesser General Public License as published by  
> the Free Software Foundation, either version 3 of the License, or  
> (at your option) any later version.  
> 
> Raketeer is distributed in the hope that it will be useful,  
> but WITHOUT ANY WARRANTY; without even the implied warranty of  
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
> GNU Lesser General Public License for more details.  
> 
> You should have received a copy of the GNU Lesser General Public License  
> along with Raketeer.  If not, see <https://www.gnu.org/licenses/>.  
