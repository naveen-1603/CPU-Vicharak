`timescale 1ns / 1ps

module PC (
    input wire CLK,
    input wire RESET,
    input wire pc_en,
    input wire [7:0] pc_ld,
    input wire pc_ld_en,
    output reg [7:0] address
);

    reg [3:0] prev_pc_ld;

    always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        address <= 8'h00;
    end else if (pc_ld_en) begin
        address <= pc_ld;
    end else if (pc_en) begin
        address <= address + 1;
    end
end


endmodule




