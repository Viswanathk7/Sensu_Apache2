#!/usr/bin/env ruby
#
# Check Cpu Load
#

require 'sensu-plugin/check/cli'

class CpuLoad < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 75

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 100

 def run

usage=0
cpuload=0

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('CPULoad')
	  	usage= proc
	  	cpuload=usage.split(":")
	  	
	  end
               end
unknown "invalid metric" if config[:crit] > 100 or config[:warn] > 100
            
            message "#{cpuload[1]} Cpuload returned"
            critical if cpuload[1].to_i > config[:crit]
	    warning if cpuload[1].to_i > config[:warn]
	    ok

 end
end
