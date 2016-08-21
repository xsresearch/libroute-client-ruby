module Libroute

  class << self

  CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = { "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

  #
  # Return a structure describing the options.
  #
  def parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.library = []
    options.build = []
    options.params = []
    options.showhelp = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: libroute.rb [options]"

      opts.separator ""
      opts.separator "Required:"

      # Mandatory argument.
      #opts.on("-r", "--require LIBRARY",
      #        "Require the LIBRARY before executing your script") do |lib|
      #  options.library << lib
      #end

      opts.on("-l", "--lib LIBRARY","Name of the LIBRARY") do |lib|
        options.library = lib
      end

      opts.separator ""
      opts.separator "Options:"

      opts.on("-b","--build DIR","Build the library from the specified directory") do |o|
        options.build = o
      end

      opts.on("-p","--params PARAMETERS","Parameters","Comma separated list of parameters") do |p|
        options.params = p
      end

      opts.on_tail("-h", "--help", "Show command options","Show library options (-l LIBRARY)") do |h|
        if options.library.empty?
          puts opts
          exit
        else
          options.showhelp = h
        end
      end

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts Libroute::VERSION
        exit
      end
    end

    opt_parser.parse!(args)
    options

  end  # parse()

  end

end

