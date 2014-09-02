#localcast


Stream your local media to Chromecast


## Setup

```bash
npm install -g nodewebkit
npm install -g nw-gyp
npm install -g grunt-cli
npm install -g bower
npm install
```
In order to find a Chromecast on the network this project relies on a module called mdns2, which needs to be natively compiled on every platform. For more information on how to do this and the required tools look [here](https://github.com/rogerwang/node-webkit/wiki/Build-native-modules-with-nw-gyp) or [here](https://github.com/TooTallNate/node-gyp). Use the setup ```./setup``` script or follow the manual instruction below:

##### 1. Compile Native Module

```bash
cd node_modules/nodecastor/node_modules/mdns2
nw-gyp rebuild --target=0.8.6
```
##### 2. Make module Nodewebkit Compatible
In the file ```node_modules/nodecastor/node_modules/protobufjs/ProtoBuf.js``` 

``` 
// Replace
Util.IS_NODE = (typeof window === 'undefined' || !window.window) && typeof require === 'function' && typeof process !== 'undefined' && typeof process["nextTick"] === 'function';
//with 
Util.IS_NODE = true;
```


## Run

```bash
grunt build
nodewebkit ./build
```

## System Requirements

FFmpeg must be installed on your system. (Live recoding of incompatible video files.)

## Distribution

To build standalaone excecutables for Win, OSX and Linux 32/64 run the following command. The release will be saved to the ```./dist``` directory.

```bash
grunt dist-{win, max, linux}
```

*Notice:* 
Due to the requirment to natively compile a node module you can only build standalones for your current platform. 




