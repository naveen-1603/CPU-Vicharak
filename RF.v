`timescale 1ns / 1ps

module RF (
    input  wire [3:0] reg_rd1,   
    input  wire [3:0] reg_rd2,   
    input  wire [3:0] reg_wrt,   
    input  wire [7:0] wrt_dat,   
    input  wire       wrt_en,    
    input  wire       CLK,       
    output wire [7:0] rd1_dat,   
    output wire [7:0] rd2_dat    
);

    reg [7:0] registers [0:15];
    
    initial begin
        registers[8] = 8'd49; 
        registers[10] = 8'd50;
        registers[11] = 8'd0;
        registers[13] = 8'hBC; 
        registers[14] = 8'd50;
        registers[15] = 8'd0;      
    end

    
    always @(posedge CLK) begin
        if (wrt_en)
            registers[reg_wrt] <= wrt_dat;
    end
    
    assign rd1_dat = registers[reg_rd1];
    assign rd2_dat = registers[reg_rd2];

endmodule
