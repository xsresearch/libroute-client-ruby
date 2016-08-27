module Libroute

  class << self

  def build(options)
    puts "Building #{options.library} from directory #{options.build}"
    im = Docker::Image.build_from_dir(options.build) do |v|
      if (log = JSON.parse(v)) && log.has_key?("stream")
        puts log["stream"]
      end
    end
    im.tag('repo' => 'libroute_image-'+options.library)
  end

  def exec(library, params)

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
      image = Docker::Image.all.select{|x| x.info['RepoTags'][0].split(':')[0].include?('libroute_image-' + library)}.first
      c = Docker::Container.create('Image' => image.id, 'name' => 'libroute_instance-' + library, 'Tty' => true)
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
