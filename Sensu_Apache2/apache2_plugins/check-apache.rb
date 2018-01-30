#!/usr/bin/env ruby

procs = `service --status-all`
running = false
procs.each_line do |proc|
  running = true if proc.include?('apache2')
end
if running
  puts 'OK - Apache service is running'
  exit 0
else
  puts 'WARNING - Apache service is NOT running'
  exit 1
end
