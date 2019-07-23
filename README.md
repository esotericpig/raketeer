# Raketeer

[![Gem Version](https://badge.fury.io/rb/raketeer.svg)](https://badge.fury.io/rb/raketeer)

[![Source Code](https://img.shields.io/badge/source-github-%23A0522D.svg?style=for-the-badge)](https://github.com/esotericpig/raketeer)
[![Changelog](https://img.shields.io/badge/changelog-md-%23A0522D.svg?style=for-the-badge)](CHANGELOG.md)
[![License](https://img.shields.io/github/license/esotericpig/raketeer.svg?color=%23A0522D&style=for-the-badge)](LICENSE.txt)

My Ruby Rake Tasks.

Name comes from Rocketeer.

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

## [Hacking](#contents)

```
$ git clone 'https://github.com/esotericpig/raketeer.git'
$ bundle install
$ bundle exec rake -T
```

## [License](#contents)

[GNU LGPL v3+](LICENSE.txt)

> Raketeer (<https://github.com/esotericpig/raketeer>)  
> Copyright (c) 2019 Jonathan Bradley Whited (@esotericpig)  
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
