`timescale 1ns / 1ps

module IM (
    input  wire [7:0] in_addr,
    output reg  [18:0] inst
);

    reg [18:0] rom [0:255];


        initial begin
            $readmemh("instructions.mem", rom); 
        end
        

    always @(*) begin
        inst = rom[in_addr];
    end

endmodule

