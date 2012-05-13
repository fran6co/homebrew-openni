require 'formula'

class SensorKinect < Formula

  homepage 'https://github.com/totakke/openni-formula'
  url 'https://github.com/avin2/SensorKinect/tarball/master'
  version '5.0.3.3'
  md5 '' # TODO

  @@redist_dir_name = 'Sensor-Bin-MacOSX-v5.0.3.3'

  devel do
    url 'https://github.com/avin2/SensorKinect/tarball/unstable'
    version '5.1.0.25-unstable'
    md5 '' # TODO

    @@redist_dir_name = 'Sensor-Bin-MacOSX-v5.1.0.25'
  end

  depends_on 'openni'

  def install

    config_dir = "#{etc}/primesense"
    
    cd 'Platform/Linux/CreateRedist'

    # Build SnesorKinect
    system 'chmod u+x RedistMaker'
    system './RedistMaker'

    cd '../Redist/' + @@redist_dir_name

    # Create config directory
    if !File.exist?(config_dir) then
      mkdir config_dir
    end

    # Install bins
    bin.install Dir['Bin/*']

    # Install libs
    lib.install Dir['Lib/*']

    # Register modules
    # NOTE: Need to create /var/lib/ni direcotry for registering modules.
    #       A user need to register them manually after installing.
#    system "#{bin}/niReg -r #{lib}/libXnDeviceSensorV2.dylib #{etc}/primesense"
#    system "#{bin}/niReg -r #{lib}/libXnDeviceFile.dylib #{etc}/primesense"

    # Copy config file
    system 'cp -f Config/GlobalDefaults.ini ' + config_dir

    # Manual setup instruction
    ohai 'Please setup manually:

  $ sudo mkdir /var/lib/ni
  $ sudo niReg -r /urr/local/lib/libXnDevice*.dylib /usr/local/etc/primesense
  $ sudo mkdir -p /var/log/primesense/XnSensorServer
  $ sudo chmod a+w /var/log/primesense/XnSensorServer
'
  
  end
    
end