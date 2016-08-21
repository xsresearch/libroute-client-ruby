# Libroute
{http://libroute.io Home}
{https://github.com/xsresearch/libroute-client-ruby GitHib}

Libroute is a generic client interface to libraries which standardises and simplifies the process of running third party libraries.

No need to battle with compile and build processes - install libroute once for a standard interface to third party libraries providing compute, scientific and mathematical functions.

Libroute offers several benefits over installing libraries locally:

* **Automated installation**

No manual compile, build or installation process, start using third party libraries within minutes.

* **Efficient processing**

Interact with the library in its native language with a common, straightforward interface.

* **Cross-platform capability**

Make calls to the library using standard TCP sockets from any platform, anywhere.

**Quick start tutorial**

Visit the {http://libroute.io/getting-started getting started} page for a 5 minute tutorial on using libroute.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'libroute'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install libroute

Note: Docker is required to use libroute. This can be installed depending on your operating system using either of the following:

    $ apt-get install docker
    $ yum install docker

## Libroute Client Usage

Libroute is installed on the command line. The full range of options can be obtained by running the command:

    $ libroute --help

Running libroute consists of 3 steps

1. Downloading the library onto your local machine
2. Building and installing the library (an automated process)
3. Running the library using the libroute command

### Downloading the library

First download and extract the library to a local directory. See the {http://libroute.io/libraries libroute libraries} page for instructions on how to download the currently supported libraries.

If the library you wish to use is not supported, see the section on 'Adding support for additional libraries' below.

### Building and installing the library

To build a library called mylib which has been downloaded to /home/user/mylib, use the command:

    $ libroute -l MYLIB -b /home/user/mylib

The library will be built and installed. This process can take several minutes after which the library will be ready for use.

### Running the library

The installed library can be run either from the command line or directly from Ruby.

#### From the command line

To run a library called mylib with parameters param1 and param2 with values value1 and value2 correspondingly, use the command:

    $ libroute -l mylib -p "param1=value1,param2=value2"

#### From Ruby

If necessary, require that the gem is loaded using:

```ruby
require 'libroute'
```

The following example shows how to launch a library called mylib with parameters param1 and param2 equal to value1 and value2:

```ruby
l = Libroute.exec('mylib', {'param1'=>'value1','param2'=>'value2'})
```

The return value is a Hash object with keys and values set. Check each library interface implementation for details on the return values.


### Supporting additional libraries

Support for additional libraries can be added by implementing the libroute-component interface.

See the libroute-component gem for more information on how to do this.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xsresearch/libroute-client-ruby

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

