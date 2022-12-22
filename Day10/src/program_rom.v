module program_rom(
    input      [15:0] address,
    output reg [3:0]  opcode_out,
    output reg [11:0] data_out
    );

reg [15:0] rom[0:255];

initial
    $readmemh("input", rom);

always @*
begin
    {opcode_out, data_out} = rom[address[7:0]];
end

endmodule;