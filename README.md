
### Repositories
- [Docker Hub repository](https://registry.hub.docker.com/u/kalaksi/tinyproxy/)
- [GitHub repository](https://github.com/kalaksi/docker-tinyproxy)

### Why use this container?
**Simply put, this container has been written with simplicity and security in mind.**

Surprisingly, _many_ community containers run unnecessarily with root privileges by default and don't provide help for dropping unneeded CAPabilities either.
Additionally, overly complex shell scripts and unofficial base images make it harder to verify the source.  

To remedy the situation, these images have been written with security and simplicity in mind. See [Design Goals](#design-goals) further down.

### Running this container
At the moment, I'm not providing full commands here.  
I assume you're experienced enough to know how to run containers.  

#### Supported tags
See the ```Tags``` tab on Docker Hub for specifics. Basically you have:
- The default ```latest``` tag that always has the latest changes.
- Minor versioned tags (follow Semantic Versioning), e.g. ```1.1``` which would follow branch ```1.1.x``` on GitHub.

#### Configuration
See ```Dockerfile``` and ```docker-compose.yml``` (<https://github.com/kalaksi/docker-tinyproxy>) for usable environment variables. Variables that are left empty will use default values.  
If you need more customization, mount your own tinyproxy.conf to ```/etc/tinyproxy/tinyproxy.conf```,
otherwise, the default tinyproxy configuration file will be used and customized according to the environment variables.

##### Considerations for the native configuration file
**This section doesn't apply to the current version (but is relevant for the future release)!**  
Note that you can't use /dev/stdout directly as the logfile: <https://github.com/tinyproxy/tinyproxy/issues/43>.  
The proper way to get Tinyproxy to log to stdout is to disable ```LogFile``` and ```Syslog``` on the configuration
so make sure that's how your file is set up.

### Development
#### Design Goals
- Never run as root unless necessary.
- Use only official base images.
- Provide an example ```docker-compose.yml``` that also shows what CAPabilities can be dropped.
- Offer versioned tags for stability.
- Try to keep everything in the Dockerfile (if reasonable, considering line count and readability).
- Don't restrict configuration possibilities: provide a way to use native config files for the containerized application.
- Handle signals properly.

#### Contributing
See the repository on <https://github.com/kalaksi/docker-tinyproxy>.
All kinds of contributions are welcome!

### License
View [license information](https://github.com/kalaksi/docker-tinyproxy/blob/master/LICENSE) for the software contained in this image.  
As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).  
  
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
