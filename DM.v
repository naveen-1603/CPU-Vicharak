`timescale 1ns / 1ps


module DM (
    input  wire        CLK,        
    input  wire        wrt_en,     
    input  wire [7:0]  address,    
    input  wire [7:0]  wrt_data,   
    output      [7:0]  rd_data     
);

    reg [7:0] mem [0:255];
    
    initial begin
        mem[0]  = 8'd0;
        mem[1]  = 8'd1;
        mem[2]  = 8'd2;
        mem[3]  = 8'd3;
        mem[4]  = 8'd4;
        mem[5]  = 8'd5;
        mem[6]  = 8'd6;
        mem[7]  = 8'd7;
        mem[8]  = 8'd8;
        mem[9]  = 8'd9;
        mem[10] = 8'd10;
        mem[11] = 8'd11;
        mem[12] = 8'd12;
        mem[13] = 8'd13;
        mem[14] = 8'd14;
        mem[15] = 8'd15;
        mem[16] = 8'd16;
        mem[17] = 8'd17;
        mem[18] = 8'd18;
        mem[19] = 8'd19;
        mem[20] = 8'd20;
        mem[21] = 8'd21;
        mem[22] = 8'd22;
        mem[23] = 8'd23;
        mem[24] = 8'd24;
        mem[25] = 8'd25;
        mem[26] = 8'd26;
        mem[27] = 8'd27;
        mem[28] = 8'd28;
        mem[29] = 8'd29;
        mem[30] = 8'd30;
        mem[31] = 8'd31;
        mem[32] = 8'd32;
        mem[33] = 8'd33;
        mem[34] = 8'd34;
        mem[35] = 8'd35;
        mem[36] = 8'd36;
        mem[37] = 8'd37;
        mem[38] = 8'd38;
        mem[39] = 8'd39;
        mem[40] = 8'd40;
        mem[41] = 8'd41;
        mem[42] = 8'd42;
        mem[43] = 8'd43;
        mem[44] = 8'd44;
        mem[45] = 8'd45;
        mem[46] = 8'd46;
        mem[47] = 8'd47;
        mem[48] = 8'd48;
        mem[49] = 8'd49;
        
    end

    assign rd_data = (wrt_en == 1'b0) ? mem[address] : 8'd0;

    
    always @(posedge CLK) begin
        if (wrt_en) begin
            mem[address] <= wrt_data;
            end
    end

  

endmodule
