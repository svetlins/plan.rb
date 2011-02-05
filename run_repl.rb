#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'scheme'

def draw_welcome_note logo
    width = logo.split("\n").max { |x,y| x.length - y.length }.length

    puts logo.strip
    puts '-' * width
end

logo = "
     |                    |    
,---.|    ,---.,---. ,---.|---.
|   ||    ,---||   | |    |   |
|---'`---'`---^`   'o`    `---'
|                              
"

draw_welcome_note logo

Scheme::run_repl
