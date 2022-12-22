module crt_controller(
    input       clk,
    input       reset,
    input [5:0] sprite_pos,
    output reg  pixel
    );

reg [5:0] pos;
reg [5:0] pos_nxt;

always @(posedge clk or posedge reset)
    if (reset)
        pos <= 1;
    else
        if (pos_nxt == 41)
            pos <= 1;
        else
            pos <= pos_nxt;

always @*
begin
    pos_nxt = pos + 1;
    if (pos == sprite_pos || pos == sprite_pos + 1 || pos == sprite_pos + 2)
        pixel = 1;
    else
        pixel = 0;
end

endmodule;