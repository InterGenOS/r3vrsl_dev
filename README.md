![alt text](https://github.com/InterGenOS/r3vrsl_dev/blob/master/R3VRSL-logo-reverse_400x250.png "R3VRSL")
# r3vrsl_dev
BEHAVIORAL | CODE | MEMORY
---


### Project Notes:
---
  Custom Grub Splash (Rough Scaled Screenshot from Virtualbox build)


  ![alt text](https://github.com/InterGenOS/r3vrsl_dev/blob/master/CustomGrub_Screenshot_500x232.png "R3VRSL")


```
  2-17-2016
  =========
  Completed 'rough build'.  1st boot success!  Screenshot pic uploaded to r3vrsl_dev share.
  Continuing Target Triplet Customization and build script development
  (more to come...)

  2-16-2016
  =========
  Temporary system has been constructed, currently being used to construct the first 'rough build', ETA 2-17/2-18
  Trial 'Target Triplet Customization' set for second build (x86_64-r3vrsl-linux), will post results after testing
  Automated build scripts have been started, will upload as I complete them

```

---

## R3VRSL - BEHAVIORAL | CODE | MEMORY
    A 64bit SysVInit Linux Distribution built from source

---

### R3VRSL Down Range - Activate System Monitoring:  down_range -on/off
---
    iNetSim        (ins) - protocol emulator
    FakeDNS       (fdns) - dns responder
    Wireshark       (ws) - protocol analysis
    Honeyd/farpd  (hdfd) - honeypot
    LiveFire        (lf) - malware repo

### 'Down Range' Commands:
---
    down_range -on                  (Starts all 'Down Range' Services)
    down_range -off                 (Stops all 'Down Range' Services)
    down_range -disable -<service>  (Removes 'Service' from 'down_range' initialization queue)
    down_range -enable -<service>   (Adds 'Service' to 'down_range' initialization queue)
---

### Additional Built-In Tools:
---
    Asn.shadowserver.org
    Automater
    Pescanner
    Psych - powershell log parser for event ID's
    WMI
    Eve - Event log parser
    Volatility/Recall - memory forensics
    Officemalscanner
    Totalhash api
    Ip api
    Virusshare api
    Indirx - script for parsing logs for ip addresses, domains without knowing regx
    Hybrid-analysis api
    YaraRG - rule generaror
    IOCmaker -
    Maltego
    Oragami framework (pdfwalker) pdf analysis
    Networkminer - pcap carving
    Virusshare api - i have api key
---
