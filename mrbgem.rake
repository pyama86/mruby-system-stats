MRuby::Gem::Specification.new('mruby-system-stats') do |spec|
  spec.license = 'MIT'
  spec.authors = 'pyama86'
  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-env'
  spec.add_dependency 'mruby-sleep'
  spec.add_dependency 'mruby-sysconf'
  spec.add_dependency 'mruby-onig-regexp'
  spec.add_dependency 'mruby-thread'
  spec.add_test_dependency 'mruby-sprintf'
  spec.cc.flags << "-DMRB_THREAD_COPY_VALUES"
end
