require File.expand_path('../test_helper', File.dirname(__FILE__))

class TC_DarwinTest < Test::Unit::TestCase
  def setup
    sample = IO.readlines("#{File.dirname(__FILE__)}"+
                          "/../../ifconfig_examples/darwin.txt").join
    netstat_sample = ""
    @cfg = IfconfigWrapper.new('BSD',sample, netstat_sample).parse
  end

  def test_interface_list
    assert(@cfg.interfaces.sort == ["en0", "fw0", "lo0"].sort,
           "Failed to parse all interfaces")
  end

  def test_mac_parse
    assert(@cfg['en0'].mac == "00:03:93:0a:16:76",
    "Failed to parse MAC address: "+@cfg['en0'].mac)
  end

  def test_flags
    assert(@cfg['en0'].flags.include?('BROADCAST') &&
          @cfg['en0'].flags.include?('RUNNING') &&
          @cfg['en0'].flags.include?('MULTICAST') &&
          @cfg['en0'].up?,
           "FLAG Parsing failed: #{@cfg['en0'].flags}")
  end

  def test_addr_types
    assert(@cfg['en0'].addr_types.include?('inet') &&
           @cfg['en0'].addr_types.include?('inet6'),
           "Failed to parse all address types")
  end

  def test_attribs
    assert(@cfg['en0'].rx['bytes'].class == Fixnum || NilClass &&
           @cfg['en0'].tx['bytes'].class == Fixnum || NilClass, "Wrong class")

  end

  def test_link_status
    assert(@cfg['en0'].status == 'active' &&
          !@cfg['fw0'].status == 'inactive',
           "Failed to parse link status")
  end

end
