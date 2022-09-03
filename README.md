# Real-Time Linker of DragonFly

The purpose of this repository is to be able to modify rtld and use it in Ravenports environment.
It's first task is to discover where unrecognized PLT relocations are coming from (e.g. R_X86_64_PC64)
