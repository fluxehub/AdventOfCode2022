#include "verilated.h"
#include "verilated_vcd_c.h"
#include "obj_dir/Vtop.h"
#include "cinttypes"
#include <algorithm>
#include <iostream>

static Vtop processor{};
static std::string display = "";

void tick() {
    processor.clk = 0;
    processor.eval();
    processor.clk = 1;
    processor.eval();
}

void reset() {
    processor.reset = 0;
    processor.eval();
    processor.reset = 1;
    processor.eval();
    processor.reset = 0;
    processor.eval();
}

// Converts a signed 12 bit value to a signed 16 bit value
int16_t signed_12bit(uint16_t value) {
    if (value & 0x800) {
        return (int16_t) (value | 0xF000);
    } else {
        return (int16_t) value;
    }
}

void print_state() {
    std::cout << "cycles: " << unsigned(processor.cycles_out) << "\t";
    std::cout << "pc: " << unsigned(processor.pc_out) << "\t";
    std::cout << "x: " << (int16_t) processor.x_out << "\t";
    std::cout << "ready: " << (int16_t) processor.ready_out << "\t";
    if (processor.opcode_out == 0) {
        std::cout << "instruction: noop" << "\t";
    } else {
        std::cout << "instruction: addx " << signed_12bit(processor.data_out) << "\t";
    }
    std::cout << "signal: " << (int16_t) processor.signal_strength_out << std::endl;
}

void step() {
    print_state();
    if (processor.pixel_out) {
        display += "#";
    } else {
        display += " ";
    }

    if (processor.cycles_out % 40 == 0) {
        display += "\n";
    }

    tick();
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    reset();

    int sum = 0;

    std::array<int, 6> notable_cycles = {20, 60, 100, 140, 180, 220};

    while(!processor.term_out) {
        auto in = std::find(std::begin(notable_cycles), std::end(notable_cycles), processor.cycles_out);
        if (in != std::end(notable_cycles)) {
            sum += processor.signal_strength_out;
        }
        step();
    }

    std::cout << "Total: " << sum << std::endl;
    std::cout << display << std::endl;
}