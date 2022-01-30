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