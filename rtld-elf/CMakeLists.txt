# Build real-time linker

set (prog ld-elf.so.2)
set (srcs
	rtld_start.S
	reloc.c
	rtld.c
	rtld_lock.c
	rtld_printf.c
	map_object.c
	malloc.c
	xmalloc.c
	debug.c
	libmap.c
)

set(rtld_pic /usr/obj/usr/src/world_x86_64/usr/src/lib/libc_rtld/libc_rtld_pic.a)

target_include_directories(
	${prog} PUBLIC
	${CMAKE_CURRENT_SOURCE_DIR}/x86_64
	${CMAKE_CURRENT_SOURCE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/../csu-common
)

add_executable(${prog} ${srcs})
target_compile_definitions(${prog} PUBLIC
	IN_RTLD
	DEBUG
	__thread
)

set(CMAKE_C_FLAGS "-fpic -DPIC")
set(RTLD_LDFLAGS
	-nostdlib
	-Wl,-e.rtld_start,--no-undefined
	-shared
	-Wl,-Bsymbolic
)
set(CMAKE_EXE_LINKER_FLAGS "${RTLD_LDFLAGS}")
set_source_files_properties(
	malloc.c
	PROPERTIES COMPILE_FLAGS
	-fno-builtin-malloc
)

# install(TARGETS ${prog} DESTINATION libexec)
# install(FILES ${prog}.1 DESTINATION share/man/man1)