`timescale 1ns / 1ps

module cpu_tb;

    reg CLK;
    reg RESET;
    
    CPU_Top uut(
        .CLK(CLK),
        .RESET(RESET)
    );
    
    always #5 CLK = ~CLK;
    
    initial begin
        
        CLK = 1;
        RESET = 1;
        
        #15;
        RESET = 0;
    end
    
endmodule
