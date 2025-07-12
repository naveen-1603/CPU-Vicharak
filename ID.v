`timescale 1ns / 1ps


module ID (
    input  wire        CLK,
    input  wire        RESET,
    input  wire [18:0] inst,           
    input  wire [ 7:0] pc_addr,         
    input  wire [ 7:0] reg2_data,        
    input  wire [ 7:0] reg1_data,
    input  wire [ 7:0] mem_rd_data,
    input  wire        zero,
    
    output reg         pc_en,          
    output reg  [7:0]  pc_ld,          
    output reg         pc_ld_en,
    output reg  [3:0]  alu_ctrl,       

    output reg         mem_wrt_en,     
    output reg  [7:0]  mem_wrt_data,
    output reg  [7:0]  mem_addr,       

    output reg         reg_wrt_en,     
    output reg  [3:0]  reg_wrt,        
    output reg  [3:0]  reg_rd1,        
    output reg  [3:0]  reg_rd2,         
    
    output reg         mux_sel
);

    // Extract fields
    wire [4:0] opcode   = inst[4:0];
    wire [3:0] dest_reg = inst[8:5];
    wire [3:0] reg1      = inst[12:9];
    wire [3:0] reg2      = inst[16:13];
    wire [7:0] branch_address = {1'b0,1'b0,inst[18], inst[17], inst[8], inst[7], inst[6], inst[5]};
    wire [7:0] jucl_address   = inst[12:5];
    wire [7:0] ld_address = inst[16:9];
    wire [7:0] st_address = inst[12:5];

    reg [7:0] pc_current;
    reg [7:0]SP = 255; //initialise 
    reg ret_pending = 0;
    reg store_pending;
    reg [7:0] store_addr;
    reg branch_pending;
    reg [7:0] branch_target;
    reg is_bnq;  // 1 for BNQ, 0 for BEQ
    
    reg [3:0] reg_2ld;
    reg ld_pending;
    reg [3:0] reg_2sav;
    reg st_pending;



always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        pc_en       <= 0;
        pc_ld       <= 8'd0;
        alu_ctrl    <= 4'd0;
        mem_wrt_en  <= 0;
        mem_addr    <= 8'd0;
        reg_wrt_en  <= 0;
        reg_wrt     <= 4'd0;
        reg_rd1     <= 4'd0;
        reg_rd2     <= 4'd0;
        mux_sel     <= 0;
        pc_ld_en    <= 0;
        SP          <= 8'd255;
        ret_pending <= 0;
    end 
    
    else begin

        // default values
        pc_en       <= 1;
        pc_ld_en    <= 0;
        pc_ld       <= 8'd0;
        alu_ctrl    <= opcode[3:0];
        mem_wrt_en  <= 0;
        mem_addr    <= 8'd0;
        reg_wrt_en  <= 0;
        reg_wrt     <= dest_reg;
        reg_rd1     <= reg1;
        reg_rd2     <= reg2;
        pc_current  <= pc_addr;
        mux_sel     <= 0;

       
        if (ret_pending) begin
            pc_ld <= mem_rd_data;   
            pc_ld_en <= 1;
            ret_pending <= 0;
        end
        
        else if (store_pending) begin
            mem_addr <= store_addr;
            mem_wrt_data <= reg2_data;
            mem_wrt_en <= 1;
            store_pending <= 0;
        end
        
        else if (ld_pending) begin
            mem_addr <= reg1_data;
            mem_wrt_en <= 0;
            mux_sel <=1;
            reg_wrt <= reg_2sav;
            ld_pending <=0;
            pc_en <=0;
            reg_wrt_en <=1;
        end
        
        else if (st_pending) begin
            mem_wrt_data <= reg1_data;
            mem_addr <= reg2_data;
            pc_en <= 0;
            st_pending <= 0;
            mem_wrt_en <=1;

        end
        
        else if (branch_pending) begin  //beq
            if ((is_bnq && zero) || (!is_bnq && !zero)) begin
                pc_ld_en <= 1;
                pc_ld <= branch_target;
            end
            branch_pending <= 0; 
        end      
             


        else begin
            case (opcode)

                5'b00000: begin // HLT
                    pc_en <= 1'b0;
                end

                5'b00001, 5'b00010, 5'b00011, 5'b00100,
                5'b00101, 5'b00110, 5'b00111, 5'b01000,
                5'b01001, 5'b01010 : begin
                    reg_wrt_en <= 1;
                end
                

                5'b01111: begin // BEQ
                    branch_target <= branch_address;
                    branch_pending <= 1;
                    pc_en <= 0;
                    is_bnq <= 0;
                end

                5'b10111: begin // BNQ
                    branch_target <= branch_address;
                    branch_pending <= 1;
                    pc_en <= 0;
                    is_bnq <= 1;
                end

                5'b01011: begin // JUMP
                    pc_ld_en <= 1;
                    pc_ld <= jucl_address;
                end

                5'b01100: begin // CALL
                    mem_addr <= SP;
                    mem_wrt_en <= 1;
                    mem_wrt_data <= pc_current + 2'd2;
                    pc_ld_en <= 1;
                    pc_ld <= jucl_address;
                    SP <= SP - 1;
                end

                5'b01101: begin // RET
                    mem_addr <= SP + 1;   
                    SP <= SP + 1;
                    ret_pending <= 1;     
                    pc_en <= 0;
                end

                5'b01110: begin // LOAD
                    mem_addr <= ld_address;
                    mux_sel <= 1;
                    reg_wrt_en <= 1;
                end

                5'b10001: begin // STORE
                    store_addr <= st_address;    
                    store_pending <= 1;
                    pc_en <= 0;
                end
                

                5'b10010: begin     // LD r1,*r2
                    reg_2sav <= dest_reg;
                    ld_pending <= 1;
                    mem_wrt_en <=0;
                    pc_en <=0;
                end
                
                5'b10011: begin      // ST *r1,r2
                    reg_rd2 <= dest_reg;
                    st_pending <= 1;
                    pc_en<=0;
                end
                
                5'b10100, 5'b10101: begin //enc,dec
                    mem_addr <= SP;
                    mem_wrt_en <= 1;
                    mem_wrt_data <= pc_current + 2'd2;
                    pc_ld_en <= 1;
                    pc_ld <= 8'd64;
                    SP <= SP - 1;
                end
                
                5'b11111: begin
                    pc_en <= 1; /////////// nop
                end
                
                default: begin
                    pc_en <= 0;
                end
            endcase
        end
    end
end

endmodule
