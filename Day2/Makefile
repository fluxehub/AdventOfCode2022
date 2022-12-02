OUT_DIR=build

${OUT_DIR}/day2: ${OUT_DIR}/day2.o 
	ld -macosx_version_min 13.0.0 -o $@ $< -lSystem -syslibroot \
		`xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64 

${OUT_DIR}/day2.o: day2.s
	@ mkdir -p ${OUT_DIR}
	as -o $@ $<