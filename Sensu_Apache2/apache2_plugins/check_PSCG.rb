#!/usr/bin/env ruby
#
# Check Parent Server Config Generation
#

require 'sensu-plugin/check/cli'

class ParentServerConfigGeneration < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 5

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 10

 def run

configgenerated=0
parentserverconfiggeneration=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('ParentServerConfigGeneration')
	  	configgenerated= proc
	  	parentserverconfiggeneration=configgenerated.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 10 or config[:warn] > 5
            
            message "#{parentserverconfiggeneration[1]} ParentServerConfigGeneration obtained"
            critical if parentserverconfiggeneration[1].to_i > config[:crit]
	    warning if parentserverconfiggeneration[1].to_i > config[:warn]
	    ok

 end
end
