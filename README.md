# mruby-system-stats   [![Build Status](https://travis-ci.org/pyama86/mruby-system-stats.svg?branch=master)](https://travis-ci.org/pyama86/mruby-system-stats)
Stats class
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'pyama86/mruby-system-stats'
end
```
## example
```ruby
puts Stats::Linux::CPU.current
```

## License
under the MIT License:
- see LICENSE file
