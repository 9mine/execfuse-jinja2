Very early PoC stage, more details coming soon 

Next command will generate execfuse-like files based on command definitions in `examples/sls.yml`
```
cat examples/sls.yml | docker run --rm -i diervi/execfuse-jinja2:master | tar xvf - -C .
```

The result should looks like
```
$ tree slsfs
slsfs
├── getattr
├── readdir
├── read_file
└── write_file
```

Then, you can mount this filesystem with execfuse

```
$ mkdir -p /mnt/slsfs
$ execfuse ./slsfs /mnt/slsfs

$ tree /mnt/slsfs
/tmp/aaa/
├── ctl
│   └── kubeless
│       ├── nodejs
│       └── python
└── funcs
    ├── fission
    └── kubeless
        ├── helo
        └── echojson
```

Also, you can share this filesystem over 9p protocol with:

```
$ docker run -p 0.0.0.0:1918:1917 --device /dev/fuse --name execfuse-test -d --cap-add SYS_ADMIN --privileged dievri/9p-execfuse-jinja2:master
0e3fbcc83d29562aff688ab0d2b401d7f1b5c7d2bdb597c705b7a8f3540ea098
$ emu-g
; mkdir ./execfuse-test
; mount -A tcp!127.0.0.1!1918  ./execfuse-test
; ls ./execfuse-test
execfuse-test/ctl
execfuse-test/funcs
```
