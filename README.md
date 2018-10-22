# 8-Bit-Reactive

A demo of Realm db in a simple AR app. 

### Building and Running

Backend is a dockerized Rails service with some scripts for getting started:

```shell
./scripts/build.sh
./scripts/run.sh
```

The Xcode project currently whitelists a hard-coded IP address for the local network (both in APIClient.swift and
in the Info.plist for the transport-layer security whitelist). The app will still function without the backend 
(surprise!) but if you want to have the full end-to-end experience, you'll need to find your computers IP and
update the Xcode project. You'll also need to expose/clear port 3000 (default Rails port).

### Credits

AR components largely based on the Ray Wenderlich AR  tutorial [here](https://www.raywenderlich.com/378-augmented-reality-and-arkit-tutorial).