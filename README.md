# CommandServer #

Library to put commands into running ruby process via socket.

You can check status of the process and execute methods.


## Install ##

    gem install command_server

## Usage ##

    require 'command_server'

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

And then, put a command from 'cmdshell'

    $ cmdshell /tmp/some_work_socket show_threads
    #<Thread:0x007f88728cb7c8>
    #<Thread:0x007f88729e1c48>
    #<Thread:0x007f88729e10b8>

Or put commands interactively

    $ cmdshell /tmp/some_work_socket
    (/tmp/some_work_socket)> help
    Available commands:
      eval
      help
      show_pid
      show_threads
    (/tmp/some_work_socket)> show_pid
    2971
    (/tmp/some_work_socket)> show_threads
    #<Thread:0x007f88728cb7c8>
    #<Thread:0x007f88729e1c48>
    #<Thread:0x007f88729e10b8>
    (/tmp/some_work_socket)> eval puts self
    main


## License ##

This software is released under the MIT License, see LICENSE.txt.
