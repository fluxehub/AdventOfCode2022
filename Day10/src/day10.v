module signal_processor(
    input clk,
    input reset,
    output reg [15:0] cycles_out,
    output reg [15:0] x_out,
    output reg [31:0] signal_strength_out,
    output reg [15:0] pc_out,
    output reg        ready_out,
    output reg [3:0]  opcode_out,
    output reg [11:0] data_out,
    output wire       term_out
    );

localparam NOOP = 4'b0000;
localparam ADDX = 4'b0001;
localparam TERM = 4'b1111;

reg [15:0] x_accum;

reg [15:0] cycles;
reg [15:0] pc;

reg  [3:0] opcode;
reg [11:0] data;

reg        add_x_flag;
reg        add_x_flag_nxt;

reg        ready;

assign cycles_out = cycles;
assign x_out = x_accum;
assign pc_out = pc;
assign ready_out = ready;
assign opcode_out = opcode;
assign data_out = data;

program_rom u_rom(
    .address(pc),
    .opcode_out(opcode),
    .data_out(data)
    );

always @(posedge clk or posedge reset)
    if (reset)
    begin
        x_accum <= 1;
        cycles <= 1;
        pc <= 0;
    end
    else
    begin
        cycles <= cycles + 1;
        x_accum <= x_accum + (add_x_flag ? {{4{data[11]}}, data[11:0]} : 0);
        pc <= pc + (ready ? 1 : 0);
        add_x_flag <= add_x_flag_nxt;
    end

always @*
begin
    term_out = 0;
    case (opcode)
        NOOP: begin
            add_x_flag_nxt = 0;
            ready = 1;
        end
        ADDX: begin
            if (!add_x_flag) 
            begin
                add_x_flag_nxt = 1;
                ready = 0;
            end
            else 
            begin
                add_x_flag_nxt = 0;
                ready = 1;
            end
        end
        TERM: begin
            add_x_flag_nxt = 1'bx;
            ready = 1'bx;
            term_out = 1;
        end
        default: begin 
            add_x_flag_nxt = 1'bx;
            ready = 1'bx;
        end
    endcase

    signal_strength_out = x_accum * cycles;
end
endmodule;