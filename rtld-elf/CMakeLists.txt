# Build real-time linker

enable_language(C ASM)

set (prog ld-elf.so.2)
set (srcs
	malloc.c
	map_object.c
	xmalloc.c
	debug.c
	libmap.c
	rtld.c
	rtld_lock.c
	rtld_printf.c
	x86_64/reloc.c
	x86_64/rtld_start.S
)

add_executable(${prog} ${srcs})
set(rtld_pic /usr/obj/usr/src/world_x86_64/usr/src/lib/libc_rtld/libc_rtld_pic.a)

target_include_directories(
	${prog} PUBLIC
	${CMAKE_CURRENT_SOURCE_DIR}/x86_64
	${CMAKE_CURRENT_SOURCE_DIR}
	${CMAKE_CURRENT_SOURCE_DIR}/../csu-common
)

target_compile_definitions(${prog} PUBLIC
	IN_RTLD
	DEBUG
	__thread=
)

set(CMAKE_C_FLAGS "-fpic -DPIC -std=gnu99 -g")

set(CMAKE_EXE_LINKER_FLAGS "-nostdlib -Wl,-e.rtld_start,--no-undefined -shared -Wl,-Bsymbolic -Wl,--version-script=Version.map")
set_source_files_properties(
	malloc.c
	PROPERTIES COMPILE_FLAGS
	-fno-builtin-malloc
)

target_link_libraries(${prog} ${rtld_pic})

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Version.map
	DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../utils/gen_map.sh
	COMMAND /bin/sh ${CMAKE_CURRENT_SOURCE_DIR}/../utils/gen_map.sh "${CMAKE_CURRENT_BINARY_DIR}"
)

add_custom_target(generate_map DEPENDS Version.map)
add_dependencies(${prog} generate_map)

# install(TARGETS ${prog} DESTINATION libexec)
# install(FILES ${prog}.1 DESTINATION share/man/man1)
