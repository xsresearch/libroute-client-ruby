module Libroute

  class << self

  def upload(options, params)
    if params['tarfile'].nil?
      puts "Parameter 'tarfile' not specified"
      exit 1
    end
    
    user = ENV['LIBROUTE_USER']
    host = ENV['LIBROUTE_HOST']
    port = ENV['LIBROUTE_PORT']

    if user.nil? then puts "Environment variable LIBROUTE_USER not defined" ; exit 1 end
    if host.nil? then host = "libroute.io" end
    if port.nil? then port = 80 end

    uri = URI.parse("http://#{host}:#{port}/#{user}/libraries/#{options.library}/upload")
    header = {'Content-Type': 'application/octet-stream'}
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = params['tarfile'].data
    response = http.request(request)
  end

  def build(options)
    puts "Building #{options.library} from directory #{options.build}"
    begin
      im = Docker::Image.build_from_dir(options.build) do |v|
        if (log = JSON.parse(v)) && log.has_key?("stream")
          puts log["stream"]
        end
      end
      im.tag('repo' => 'libroute_image-'+options.library)
    rescue
      puts "Libroute: An error occurred during the build process.\n\n"
    end
  end

  def exec(library, params, opts={})

    # Check if existing container running
    c = Docker::Container.all(all: true).select{|c| c.info['Names'][0].eql?('/libroute_instance-' + library)}

    if c.length == 1
      # Check status
      if c[0].info['State'].eql?('exited')
        # Kill and request start
        c[0].delete
        c = []
      end
    end

    if c.length == 0

      # Launch container from image

      imagemap = Docker::Image.all.flat_map{|x| x.info['RepoTags'].count == 1 ? [[x.info['RepoTags'][0],x]] : x.info['RepoTags'].map{|y| [y,x]} }
        # This command splits multiple tags into a flat vector
        # -> imagemap is a vector of length equal to the number of images
        # => each elements is a vector of length 2: [tag, image]

      imagesel = imagemap.select{|x| x[0].split(':')[0].include?('libroute_image-' + library)}

      if imagesel.count == 0
        h = Hash.new
        h['stderr'] = 'Image not found'
        return h
      end

      image = imagesel[0][1]

      c = Docker::Container.create({'Image' => image.id, 'name' => 'libroute_instance-' + library, 'Tty' => true}.merge(opts))
      c.start

      # Wait for container to start
      sleep 1

    else
      c = c[0]
    end

    ip_address = c.json['NetworkSettings']['IPAddress']

    # Send and retrieve data from container
    #s = TCPSocket.new(ip_address, 2000)
    #s.write(Marshal.dump(params))
    #s.close_write
    #outp = Marshal.load(s.read)
    #s.close

    s = TCPSocket.new(ip_address, 2000)
    bb = params.to_bson
    s.write(bb.get_bytes(bb.length))
    s.close_write
    data = s.read
    bb = BSON::ByteBuffer.new(data)
    outp = Hash.from_bson(bb)
    s.close

    # Return response
    return outp

  end
  end

end
