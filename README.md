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



```
