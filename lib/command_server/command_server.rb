require 'socket'

class CommandServer

  def initialize
    @cmds = {}
  end

  def start addr
    @addr = addr
    @server = UNIXServer.new(@addr)
    $stderr.puts "[CommandServer] Server start: #{@addr}"

    at_exit do
      stop
    end

    @accept_thread = Thread.new do
      @accept_thread.abort_on_exception = true
      loop do
        accept_and_process
      end
    end

  end

  def stop
    File.unlink @addr
    @accept_thread.exit
  end

  def register_command name, proc_obj, description=""
    @cmds[name] = {proc: proc_obj, desc: description}
  end

  def enable_builtin_command name
    proc_name = "builtin_command_#{name}"
    if self.respond_to?(proc_name, true)
      register_command name, method(proc_name.to_sym)
    else
      raise NameError.new("Undefined builtin command: #{name}")
    end
  end

  private
  def accept_and_process

    sock = @server.accept
    cmdline = sock.gets.chomp.strip
    parts = cmdline.split(" ", 2)
    cmd = parts[0]
    arg = parts[1]
    $stderr.puts "[CommandServer] Command received: #{cmdline}"
    if @cmds.include?(cmd)
      cmd_method = @cmds[cmd][:proc]
      cmd_t = Thread.new do
        cmd_t.abort_on_exception = true
        stdout = $stdout
        begin
          $stdout = sock
          cmd_method.call(arg)
        rescue StandardError, ScriptError => e
          msg = "#{e.backtrace.shift}: #{e.message} (#{e.class.to_s})\r\n"
          while(str = e.backtrace.shift)
            msg << "\t#{str}\r\n"
          end
          $stderr.puts msg
          sock.puts msg
        ensure
          $stdout = stdout
          sock.close
        end
      end
    else
      $stderr.puts "[CommandServer] Invalid command: #{cmd}"
      sock.puts "Invalid command: #{cmd}"
      sock.close
    end
  end

  def builtin_command_eval(arg)
    eval(arg, Object::TOPLEVEL_BINDING)
  end

  def builtin_command_help(arg)
    puts "Available commands:"
    @cmds.sort.each do |key, item|
      puts "  #{key}"
    end
  end

end

if $0 == __FILE__

  class SomeWorkClass

    def initialize
      @cmdserver = CommandServer.new
      @cmdserver.enable_builtin_command("eval");
      @cmdserver.enable_builtin_command("help");
      @cmdserver.register_command("show_threads", proc{ puts Thread.list })
      @cmdserver.register_command("show_pid", proc{ puts $$ })
      @cmdserver.start("/tmp/some_work_socket")
    end

  end

  SomeWorkClass.new
  sleep

end
