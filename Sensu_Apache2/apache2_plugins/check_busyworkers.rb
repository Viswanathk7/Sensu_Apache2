#!/usr/bin/env ruby
#
# Check Busy Workers
#

require 'sensu-plugin/check/cli'

class BusyWorkers < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 40

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 50

 def run

workers=0
busy_workers=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('BusyWorkers')
	  	workers= proc
	  	busy_workers=workers.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 10000 or config[:warn] > 10000
            
            message "#{busy_workers[1]} BusyWorkers returned"
            critical if busy_workers[1].to_i > config[:crit]
	    warning if busy_workers[1].to_i > config[:warn]
	    ok

 end
end
