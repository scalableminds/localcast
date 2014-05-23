localhost
=========

Stream your local media to Chromecast


## Setup

```bash
npm install -g nodewebkit
npm install -g nw-gyp
npm install -g grunt-cli
npm install -g bower
npm install

// on OSX apply a patch and compile a lib for 32bit Nodewebkit
./setup
```


## Run

```bash
grunt build
nodewebkit ./build
```

## Cross Platform Builds

```bash
grunt dist
```

This will build excecutables for Win64, OSX and Linux 32/64 in the ./dist directory.


