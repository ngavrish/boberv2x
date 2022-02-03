Scripts to build OpenWRT for Banana pi R64(at the moment using R2).

### TODO
- Inside the openwrt configure network
- Improve the the script
- Prepare config file for the Banana Pi R64

### Requirements
As mentioned on [OpenWRT](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem) need to be installed

```
binutils bzip2 diff find flex gawk gcc-6+ getopt grep install libc-dev libz-dev
make4.1+ perl python3.6+ rsync subversion unzip which
```

### Quickstart
	- scripts/build.sh
		-d Download and Fetches required source files from https://github.com/openwrt/openwrt
		-b Will build the image

In order to enable the WAN port accesible over the LUCI should to add this line on `/etc/config/firewall` 
```
config rule                                                                     
        option name 'luci'                                                      
        option src 'wan'                                                        
        option target 'ACCEPT'                                                  
        option proto 'tcp'                                                      
        option dest_port '443'                                                  
                                                                                
config rule                                                                     
        option name 'ssh'                                                       
        option src 'wan'                                                        
        option target 'ACCEPT'                                                  
        option proto 'tcp'                                                      
        option dest_port '22'                                                   
                                                                                
config rule                                                                     
        option name 'luci'                                                      
        option src 'wan'                                                        
        option target 'ACCEPT'                                                  
        option proto 'tcp'                                                      
        option dest_port '80'  
```
will add this to automation config, at the moment working on it, also automatically configure the network

### Banana PI R64 Test Experience
#### Banana PI R64 Openwrt without 802.11p patches
- build on latest(31-Jan) Master branch without issue(generates SD image, sysupgrade, etc)
- before the Dec 14 on master branch has issue with persistance, not properly mouting the MTD block(generates SD image, sysupgrade, etc)
- OpenWRT 21.02 uses kernel 5.4 generates sysupgrade bin, which is fails on flashing

#### Banana PI R64 Openwrt with 802.11p patches
- build on latest(31-Jan) Master branch has issue with the patch, kernel and mac80211 has some changes, which requirering modification on patch like
`res = nl80211_prepare_wdev_dump(cb, &rdev, &wdev, NULL);`
- before the Dec 14 on master branch with patches build without issue
- both of the version will have issue while running on openwrt the `iw` tool espessilly when running below commands CPU stacks, but sometimes run without issue
```
iw dev wlan0 set type ocb
echo "Turn on wlan0"
ifconfig wlan0 up
```

#### The Next steps
- Try to build with OpenWRT 21.02 which used on OperWRT-V2X, where it requires some modification on kernel 5.4 to make it work on BPI R64


#### Note
Banana PI R64 SoC become hot when integrated WIFI enabled MT7615, when it's disabled working fine
