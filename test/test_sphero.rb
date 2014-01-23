require 'minitest/autorun'
require 'sphero'
require 'mocha/setup'

class TestSphero < MiniTest::Unit::TestCase
  def setup
    Sphero.any_instance.stubs(:initialize_serialport)
    Sphero.any_instance.stubs(:initialize_socket)
    @sphero = Sphero.new 'port123'
    @seq = 0x00
  end

  def test_start_returns_new_sphero
    assert_kind_of Sphero, Sphero.start('someport')
  end

  def test_start_sphero_executes_block
    Sphero.any_instance.expects(:ping)
    Sphero.any_instance.expects(:close)
    Sphero.start('someport') do
      ping
    end
  end

  def test_ping
    Sphero::Request::Ping.expects(:new).with(@seq)
    @sphero.expects(:write)
    @sphero.ping
  end

  def test_version
    Sphero::Request::GetVersioning.expects(:new).with(@seq)
    @sphero.expects(:write)
    @sphero.version
  end

  def test_bluetooth_info
    Sphero::Request::GetBluetoothInfo.expects(:new).with(@seq)
    @sphero.expects(:write)
    @sphero.bluetooth_info
  end

  def test_auto_reconnect=
    @time_s = 10
    Sphero::Request::SetAutoReconnect.expects(:new).with(@seq, @time_s)
    @sphero.expects(:write)
    @sphero.auto_reconnect = @time_s
  end

  def test_auto_reconnect
    @time_s = 10
    packet = mock 'packet'
    packet.stubs(:time).returns(@time_s)
 
    Sphero::Request::GetAutoReconnect.expects(:new).with(@seq)
    @sphero.expects(:write).returns(packet)
    assert_equal @sphero.auto_reconnect, @time_s
  end

  def test_disable_auto_reconnect
    Sphero::Request::SetAutoReconnect.expects(:new).with(@seq, 0, 0x00)
    @sphero.expects(:write)
    @sphero.disable_auto_reconnect
  end

  def test_power_state
    Sphero::Request::GetPowerState.expects(:new).with(@seq)
    @sphero.expects(:write)
    @sphero.power_state
  end
  
  def test_sphero_sleep
    wakeup = 1
    macro = 2
    Sphero::Request::Sleep.expects(:new).with(@seq, wakeup, macro)
    @sphero.expects(:write)
    @sphero.sphero_sleep wakeup, macro
  end

  def test_stabilization
    Sphero::Request::Stabilization.expects(:new).with(@seq, true)
    @sphero.expects(:write)
    @sphero.stabilization = true
  end

  def test_roll
    speed = 1
    heading = 2
    state = 1
    Sphero::Request::Roll.expects(:new).with(@seq, speed, heading, state)
    @sphero.expects(:write)
    @sphero.roll speed, heading, true
  end

  def test_roll_upper_limit
    heading = 2
    state = 1
    Sphero::Request::Roll.expects(:new).with(@seq, 255, heading, state)
    @sphero.expects(:write)
    @sphero.roll 300, heading, true
  end

  def test_roll_lower_limit
    heading = 2
    state = 1
    Sphero::Request::Roll.expects(:new).with(@seq, 0, heading, state)
    @sphero.expects(:write)
    @sphero.roll( -10, heading, true )
  end

  def test_roll_limit_conversion
    heading = 2
    state = 1
    Sphero::Request::Roll.expects(:new).with(@seq, 123, heading, state)
    @sphero.expects(:write)
    @sphero.roll 123.4, heading, true
  end

  def test_roll_upper_wrap
    speed = 3
    state = 1
    Sphero::Request::Roll.expects(:new).with(@seq, speed, 1, state)
    @sphero.expects(:write)
    @sphero.roll speed, 361, true
  end

  def test_roll_lower_wrap
    speed = 3
    state = 1
    Sphero::Request::Roll.expects(:new).with(@seq, speed, 359, state)
    @sphero.expects(:write)
    @sphero.roll( speed, -1, true )
  end

  def test_roll_limit_wrap
    speed = 3
    state = 1
    Sphero::Request::Roll.expects(:new).with(@seq, speed, 123, state)
    @sphero.expects(:write)
    @sphero.roll speed, 123.4, true
  end

  def test_stop
    @sphero.expects(:roll).with(0, 0)
    @sphero.stop
  end

  def test_keepgoing
    Kernel.expects(:sleep).with(3)
    @sphero.keep_going 3
  end

  def test_directions
    assert_equal 0, Sphero::FORWARD
    assert_equal 90, Sphero::RIGHT
    assert_equal 180, Sphero::BACKWARD
    assert_equal 270, Sphero::LEFT
  end
end
