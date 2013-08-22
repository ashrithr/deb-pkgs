## Build a Storm deb

Run the following command which will create a deb package of storm-0.8.2 in /tmp

```bash
bash <(curl -s https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/install.sh)
```

To Build storm dependencies zeromq and jzmq:

```bash
bash <(curl -s https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/build_libzmq_deb.sh)
bash <(curl -s https://raw.github.com/ashrithr/deb-pkgs/master/storm-0.8/build_jzmq_deb.sh)
```
