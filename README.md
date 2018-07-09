# General

## Why use this container?
**Simply put, this container has been written with simplicity and security in mind.**

Surprisingly, _many_ community containers run unnecessarily with root privileges and don't provide help for dropping unneeded CAPabilities.  
Additionally, overly complex shell scripts and unofficial base images make it harder to verify the source.  

To remedy the situation, these images have been written with security and simplicity in mind. See Design Goals further down.

# Running this container
At the moment, I'm not providing full commands here.  
I assume you're experienced enough to know how to run this container.  

## Configuration
See ```Dockerfile``` and ```docker-compose.yml``` (<https://github.com/kalaksi/docker-tinyproxy>) for usable environment variables.  
If you need more customization, mount your own tinyproxy.conf to ```/etc/tinyproxy/tinyproxy.conf```,
otherwise, the default tinyproxy config will be used and customized according to the environment variables.

### Considerations for the native configuration file
Note that you can't use /dev/stdout directly as the logfile: <https://github.com/tinyproxy/tinyproxy/issues/43>.  
The proper way to get Tinyproxy to log to stdout is to disable LogFile and Syslog on the configuration
so make sure that's how your file is set up.

# Development
## Design Goals
- Never run as root unless necessary.
- Use only official base images.
- Provide an example ```docker-compose.yml``` which shows what CAPabilities can be dropped.
- Handle signals properly.
- Try to keep everything in the Dockerfile (if reasonable, considering line count and readability).
- Don't restrict configuration possibilities: provide a way to use native config files for the containerized application.

## Contributing
See the repository in <https://github.com/kalaksi/docker-tinyproxy>.
All kinds of contributions are welcome!
