# unofficial_nix_static_releases
Unofficial repository to distribute statically-compiled nix.


This repo has been made since sometime you only require the nix evaluator, and getting nix statically-built from the hydra cache or the internet is annoying.


This flake provides:
```
└───packages
    ├───aarch64-linux
    │   ├───default: package 'all-nix-tars'
    │   ├───nix_2_26_3: package 'copy-nix-bin'
    │   ├───nix_2_27_1: package 'copy-nix-bin'
    │   ├───nix_2_28_3: package 'copy-nix-bin'
    │   └───nix_2_29_0: package 'copy-nix-bin'
    └───x86_64-linux
        ├───default: package 'all-nix-tars'
        ├───nix_2_26_3: package 'copy-nix-bin'
        ├───nix_2_27_1: package 'copy-nix-bin'
        ├───nix_2_28_3: package 'copy-nix-bin'
        └───nix_2_29_0: package 'copy-nix-bin'
```

Where "default" is to get all nix statically-compiled in a .tar.gz file, the others just gets you the binary. 