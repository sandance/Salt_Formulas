java_home:  /usr/lib/java
java:
  source_url: http://<somehost>/jdk-linux-server-x64-1.7.0.45.tar.gz
  version_name: jdk-linux-server-x64-1.7.0.45
  prefix: /usr/share/java
  dl_opts: -L

  #java:version_name is the name of the top level directory inside the tarball
  #java:prefix is where the tarball is unpacked into - prefix/version_name 
  #     the location of the jdk
  #java:dl_opts - cli args to CURL

