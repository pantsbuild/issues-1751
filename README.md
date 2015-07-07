This repo sketches out a minimal solution to https://github.com/pantsbuild/pants/issues/1751

To try the solution out you can run the following:
```console
$ git clone https://github.com/pantsbuild/issues-1751.git && \
  cd issues-1751 && \
  ./create-prebuilts.sh && \
  ./pants binary //:test && \
  ./dist/test.pex
```

This will cone the example repo, create a set of pre-built distributions for various problematic numpy ecosystem packages, and then build and "run" a binary that imports from several packages.
Note that this example includes checked-in source distributions for simplicity / locality in one example project. In practice you'd want to store the source distributions and the built distributions in a seperate location that was accessible to all folks checking out your project.  Popular choices are various webservers that can serve up the (in this example) `prebuilts/dist` directory.
