#!/usr/bin/env ruby

require "json"

require_relative "fileHandler"
require_relative "stdinHandler"
require_relative "randomHandler"
require_relative "dataModel"
require_relative "configGenerator"
require_relative "glpkHandler"

def usage
    puts "usage : #{$0} [ --stdin (-s) | --seed=seed | file ]"
    exit
end


if $*.size == 0
    donnees = getDonneesFromRandom nil
elsif $*[0] == "-h" || $*[0] == "--help"
    usage
elsif $*[0] == "--stdin" || $*[0] == "-s"
    donnees = getDonneesFromStdin
elsif ($*[0] =~ /^--seed=/) != nil
    donnees = getDonneesFromRandom $*[0].gsub(/^--seed=/, "")
elsif $*.size == 1
    donnees = getDonneesFromFile $*[0]
else
    usage
end

def configpp(conf)
    tojsonify = []

    conf.each do |pair|
        tojsonify.push pair.map { |x| x.getName }
    end
    return JSON.generate tojsonify

end

configurations = generateConfigurations donnees

computeOptimalSolution(donnees, configurations)
