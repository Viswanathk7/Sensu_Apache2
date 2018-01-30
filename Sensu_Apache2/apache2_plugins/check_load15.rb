#!/usr/bin/env ruby
#
# Check Load after 15 min
#

require 'sensu-plugin/check/cli'

class Load15 < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 5

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 10

 def run

usage=0
loadafter15min=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('Load15')
	  	usage= proc
	  	loadafter15min=usage.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 100 or config[:warn] > 100
            
            message "Load after 15 min: #{loadafter15min[1]} "
            critical if loadafter15min[1].to_i > config[:crit]
	    warning if loadafter15min[1].to_i > config[:warn]
	    ok

 end
end
