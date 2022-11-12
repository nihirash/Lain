use clap::Parser;
use log::{error, info, warn};
use simple_logger::SimpleLogger;
use std::fs::File;
use std::io::{Read, Write};
use std::net::{Ipv4Addr, TcpStream};

const CARGO_PKG_VERSION: Option<&'static str> = option_env!("CARGO_PKG_VERSION");

/// This utility used for delivery snapshot to ZX Spectrum running Lain
#[derive(Debug, Parser)]
#[command(about)]
pub struct Arguments {
    /// IP address of ZX Spectrum that's runs Lain
    pub ip: Ipv4Addr,
    /// File name of snapshot to deliver
    pub snapshot: String,
}

fn read_file(name: String) -> std::io::Result<Vec<u8>> {
    info!("Reading file '{}' ", name);
    let mut file = File::open(name)?;
    let mut buffer: Vec<u8> = Vec::new();
    file.read_to_end(&mut buffer)?;

    if buffer.len() != 49179 || buffer.len() != 131103 {
        warn!("Unusual snapshot size: {}", buffer.len());
    }

    Ok(buffer)
}

fn transmit(ip: Ipv4Addr, buffer: Vec<u8>) -> std::io::Result<()> {
    let addr = format!("{}:6144", ip);

    info!("Establishing connection to {}", &addr);
    let mut socket = TcpStream::connect(addr)?;

    info!("Writing data({} bytes)", buffer.len());
    socket.write_all(&buffer)?;

    Ok(())
}

fn process(args: Arguments) -> std::io::Result<()> {
    let file = read_file(args.snapshot.clone())?;

    transmit(args.ip, file)?;

    Ok(())
}

fn main() {
    println!(
        "sna-upload {} (c) Alex Nihirash",
        CARGO_PKG_VERSION.unwrap_or("dev")
    );
    let args = Arguments::parse();

    SimpleLogger::new().init().unwrap();

    match process(args) {
        Err(e) => error!("{}", e.to_string()),
        _ => info!("Done!"),
    }
}
