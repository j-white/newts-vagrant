newts-vagrant
=============

A simple way to start using newts:

    $ git clone https://github.com/j-white/newts-vagrant.git && cd newts-vagrant
    $ vagrant up
    $ curl -D - -X GET 'http://0.0.0.0:8080/samples/localhost.temps?start=1998-07-09T12:05:00-0500&end=1998-07-09T13:15:00-0500'; echo
