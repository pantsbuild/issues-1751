To test this repo under 64 bit CentOS 6.6 run the following from this directory:

```console
vagrant up && vagrant ssh
cd /vagrant_data && \
  ./create-prebuilts.sh && \
  ./pants binary //:test && \
  ./dist/test.pex
```
