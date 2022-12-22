module top(
    input clk,
    input reset,
    output reg [15:0] cycles_out,
    output reg [15:0] x_out,
    output reg [31:0] signal_strength_out,
    output reg [15:0] pc_out,
    output reg        ready_out,
    output reg [3:0]  opcode_out,
    output reg [11:0] data_out,
    output wire       term_out,
    output wire       pixel_out
    );

wire [15:0] sprite_pos;

signal_processor u_signal_processor(
    .clk(clk),
    .reset(reset),
    .cycles_out(cycles_out),
    .x_out(sprite_pos),
    .signal_strength_out(signal_strength_out),
    .pc_out(pc_out),
    .ready_out(ready_out),
    .opcode_out(opcode_out),
    .data_out(data_out),
    .term_out(term_out)
    );

crt_controller u_crt_controller(
    .clk(clk),
    .reset(reset),
    .sprite_pos(sprite_pos[5:0]),
    .pixel(pixel_out)
    );

endmodule;