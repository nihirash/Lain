# Lain

## Description

esxDOS dot command to upload machine code programs over the air from PC to wifi equiped ZX Spectrum(like [wload](https://github.com/mcleod-ideafix/wload) by mcleod_ideafix).

It based on two sides - Speccy part and PC part.

### ZX Spectrum part

It's creates TCP server that listen 6144 port.

It accepts connection, receives data as plain values and tries execute it as snapshot(SNA format, 48k and 128k both supported).

When you'll execute it - you'll see IP address of server and port. So you'll ready for transfering snapshot.

Speccy part preset with `lain` dot command. Just call it from basic and you'll be ready for receiving snapshot:

```
.lain
```

### PC part

Can be implemented via any TCP transmit programm starting from netcat and ending with special implemented(example in `pcutil` directory).

Simplest way(using netcat utility) similar to wload usage except you're using plain snapshots:

```
nc <ip_address_of_speccy> 6144 < test.sna
```

Also there're example tool written in Rust present.

It self documentary - just call it with `--help` key:

```
sna-upload 0.1.0 (c) Alex Nihirash
This utility used for delivery snapshot to ZX Spectrum running Lain

Usage: sna-upload <IP> <SNAPSHOT>

Arguments:
  <IP>        IP address of ZX Spectrum that's runs Lain
  <SNAPSHOT>  File name of snapshot to deliver

Options:
  -h, --help  Print help information
```

## Development

For development speccy part I'm using `sjasmplus` and GNU version of `make`. 

If you want add additional device to support - please place uart driver to `drivers` directory, logical modules should be placed to `modules` directory. 

If you have some replacement logic for some target(for example, different wifi routines) - use conditional build based on flags and implement logic in same named modules but in different files and include required file by selected target. 

## Legal

This part of software is unlicensed - it's public domain. 