#!/usr/bin/env ruby
#
# Check Idle Workers
#

require 'sensu-plugin/check/cli'

class IdleWorkers < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 20

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 10

 def run

idle=0
idle_workers=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('IdleWorkers')
	  	idle= proc
	  	idle_workers=idle.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 10000 or config[:warn] > 10000
            
            message "#{idle_workers[1]} IdleWorkers returned"
            critical if idle_workers[1].to_i < config[:crit]
	    warning if idle_workers[1].to_i < config[:warn]
	    ok

 end
end
