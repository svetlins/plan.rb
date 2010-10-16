#!/usr/bin/env ruby
libdir = `pwd`.strip
puts libdir
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'lib/scheme'

# kind of lame :)
puts "
 |                         |    
 ,---.,---.|---.,---.,-.-.,---. ,---.|---.
 `---.|    |   ||---'| | ||---' |    |   |
 `---'`---'`   '`---'` ' '`---'o`    `---'
"
puts "=" * 42

Scheme::run_repl
