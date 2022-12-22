VERILATOR_DIR=/opt/homebrew/Cellar/verilator/5.004/share/verilator/include/
VERILATOR_COMPILES=$(VERILATOR_DIR)/verilated.cpp $(VERILATOR_DIR)/verilated_vcd_c.cpp $(VERILATOR_DIR)/verilated_threads.cpp 

TOP_MODULE=signal_processor

TOP_FILE=src/day10.v
ADDITIONAL_FILES=src/program_rom.v

INPUT_FILE=input

tb: obj_dir/V$(TOP_MODULE)__ALL.a $(INPUT_FILE) tb.cpp
	clang++ -std=c++17 -I $(VERILATOR_DIR) $(VERILATOR_COMPILES) tb.cpp obj_dir/V$(TOP_MODULE)__ALL.a -o tb

$(INPUT_FILE): $(INPUT_FILE).s assembler.py
	python3 assembler.py $(INPUT_FILE).s

obj_dir/V$(TOP_MODULE)__ALL.a: $(TOP_FILE) $(ADDITIONAL_FILES)
	verilator --trace --top-module $(TOP_MODULE) -I $(ADDITIONAL_FILES) -cc $(TOP_FILE)
	make -C obj_dir -f V$(TOP_MODULE).mk

clean:
	rm -rf obj_dir
	rm -rf tb.dSYM
	rm -f tb
	rm -f $(INPUT_FILE)