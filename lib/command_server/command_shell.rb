require 'socket'

addr = ARGV[0]
cmd = ARGV[1] || ""

def proc_command(addr, cmd)

  UNIXSocket.open(addr) do |socket|
    socket.puts cmd
    while(line = socket.gets) do
      $stdout.puts line
    end
  end

rescue Errno::ENOENT

  raise IOError.new("[CommandShell] Error: Unavailable socket: #{addr}")

end


if !addr || addr.length == 0
  $stdout.puts "Usage: #{$0} <path/to/socket> [command]"
  raise ArgumentError.new("Socket path is required")
end

if cmd.length > 0
  cmdline = ARGV[1..ARGV.length].join(" ")
  proc_command(addr, cmdline)
else
  while(true) do
    print "(#{addr})> "
    cmd = $stdin.gets
    if cmd == nil
      break
    end
    cmd = cmd.chomp.strip
    if(cmd.length > 0)
      begin
      proc_command(addr, cmd)
      rescue IOError => e
        $stdout.puts e.message
      end
    end
  end
  $stdout.puts
end
