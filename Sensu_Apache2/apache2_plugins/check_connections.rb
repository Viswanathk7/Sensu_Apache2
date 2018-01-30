#!/usr/bin/env ruby
#
# Check Apache connections
#

require 'sensu-plugin/check/cli'

class CheckConnections < Sensu::Plugin::Check::CLI

  option :warn,
    :short => '-w WARN',
    :proc => proc {|a| a.to_i },
    :default => 10

  option :crit,
    :short => '-c CRIT',
    :proc => proc {|a| a.to_i },
    :default => 5

  def run
    total_connections = 0
    keepalive_connections = 0
    keepalive = 0
    total = 0
    

procs = `curl http://127.0.1.1/server-status?auto`
procs.each_line do |proc|
       	   if proc .include?('ConnsAsyncKeepAlive')
	  	keepalive= proc
	  	keepalive_connections=keepalive.split(":")
	  	
	  end
               

          if proc .include?('ConnsTotal')
	  	total= proc
	  	total_connections=total.split(":")
	  	
	  end
               end
         
           if total_connections[1].to_i == 0
              puts "0% workload obtained" 
           
           else
    
              unknown "invalid percentage" if config[:crit] > 100 or config[:warn] > 100
              workload =(keepalive_connections[1].to_i / total_connections[1].to_i) * 100
              message "#{workload}% workload obtained"

              critical if workload > config[:crit]
              warning if workload > config[:warn]
              ok
           end
    exit
  end
end

