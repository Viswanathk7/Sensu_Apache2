#!/usr/bin/env ruby
#
# Check Uptime
#

require 'sensu-plugin/check/cli'

class Uptime < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 60

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 30

 def run

up=0
uptime=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('Uptime')
	  	up= proc
	  	uptime=up.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 100000 or config[:warn] > 100000
            
            message "#{uptime[1]} Server Uptime  returned"
            critical if uptime[1].to_i > config[:crit]
	    warning if uptime[1].to_i > config[:warn]
	    ok

 end
end
