MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem mgem: 'mruby-thread'
  conf.linker.libraries << ['pthread']
  conf.gem File.expand_path(File.dirname(__FILE__))
  conf.cc.flags << "-DMRB_THREAD_COPY_VALUES"
#  conf.cc.flags << "-g3 -O0"
  conf.enable_test
end
