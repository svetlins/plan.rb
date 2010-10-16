#!/usr/bin/env ruby
libdir = `pwd`.strip
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'lib/scheme'

def draw_welcome_note logo
    width = logo.split("\n").max { |x,y| x.length - y.length }.length

    puts '-' * width
    puts logo.strip
    puts '-' * width
end

logo = "
,---.,---.|---.,---.,-.-.,---. ,---.|---.
`---.|    |   ||---'| | ||---' |    |   |
`---'`---'`   '`---'` ' '`---'o`    `---'
"

draw_welcome_note logo

Scheme::run_repl
