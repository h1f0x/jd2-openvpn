# What is this Image?

This image is a merge of two already existing docker images:

- dperson/openvpn-client (https://github.com/dperson/openvpn-client)
- jlesage/docker-jdownloader-2 (https://github.com/jlesage/docker-jdownloader-2)


# What to expect of this image?

Not to much to be honest. There are a few ugly things i needed to do to get this working:

- jDownloader VNC + App will start after 65 secs, because -
- there is a crontab entry which checks if the VPN is running every minute, -
- if not, it will start the tunnel (again?)

In order to get this working with the appstart.sh of the source image i use from jlesage/docker-jdownloader-2 i needed to implement my own ./init script which executes the crond.


**NOTE**: More than the basic privileges are needed for OpenVPN. With docker 1.2
or newer you can use the `--cap-add=NET_ADMIN` and `--device /dev/net/tun`
options. Earlier versions, or with fig, and you'll have to run it in privileged
mode.


## What can it do?

It has both world united.. more or less:

- localhost:5800 is available and running even when the vpn is up
- the vpn only works with an OpenVPN configuration file (also works with automatic auth)

# How do you run it?

    cp /path/from/config.ovpn /path/to/vpnconfigfolder/config.ovpn
    
    if user-pass-auth:
    cp /path/from/auth.file /path/to/vpnconfigfolder/auth.file
    
    docker run -it --cap-add=NET_ADMIN \
    --device /dev/net/tun --name jd2-openvpn \
    -v /path/to/vpnconfigfolder:/vpn \
    -v /docker/appdata/jdownloader-2:/config:rw \
    -v $HOME/Downloads:/output:rw \
    -d -p 5800:5800
    
    docker stop jd2-openvpn
    
    
    
If you want do have MyJDowanloader right away, modify the following file:

    vi /docker/appdata/jdownloader-2/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
    
    { "email" : "your@mailaddress.com", "password" : "yourpassword" }
    
# Advanced Settings
All options of both base images are available, but you need to modify the Dockerfile if you want to modify your VPN configuration. The command to execute the the VPN is added during the build of the image as cronjob.

To add the --dns or --firewall flag you need to recreate the image your self with the extensions in the crontab entry.

    # crontab to run vpn continousily
    RUN crontab -l | { cat; echo "*       *       *       *       *       /usr/bin/openvpn.sh"; } | crontab -
    
In the configuration documentation can be found at the repo of dperson/openvpn-client.