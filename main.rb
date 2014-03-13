#!/usr/bin/env ruby
require_relative "fileHandler"
require_relative "stdinHandler"
require_relative "dataModel"

def usage
    puts "usage : #{$0} [file]"
    exit
end


if $*.size > 1
    usage
elsif $*.size == 1
    if $*[0] == "-h" || $*[0] == "--help"
        usage
    end
    donnees = getDonneesFromFile($*[0])
else
    donnees = getDonneesFromStdin()
end




