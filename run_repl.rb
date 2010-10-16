#!/usr/bin/env ruby
libdir = `pwd`.strip
puts libdir
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'lib/scheme'

Scheme::run_repl
