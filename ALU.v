`timescale 1ns / 1ps

module ALU (
    input  [7:0] A,        
    input  [7:0] B,        
    input  [3:0] ALU_ctrl, 
    output reg [7:0] res,  
    output reg carry       
);

    reg [8:0] temp_result; 

    always @(*) begin
        carry = 0;         
        case (ALU_ctrl)
            4'b0000: begin // HLT
                res = 8'd0;
                carry = 0;
            end
            
            4'b0001: begin // ADD
                temp_result = A + B;
                res = temp_result[7:0];
                carry = temp_result[8];
            end

            4'b0010: begin // SUB
                temp_result = {1'b0, A} - B;
                res = temp_result[7:0];
                carry = temp_result[8]; 
            end

            4'b0011: begin // MUL
                res = A * B;
                carry = 0;
            end

            4'b0100: begin // DIV
                res = (B != 0) ? A / B : 8'h00; 
                carry = 0;
            end

            4'b0101: begin // AND
                res = A & B;
                carry = 0;
            end

            4'b0110: begin // OR
                res = A | B;
                carry = 0;
            end

            4'b0111: begin // XOR
                res = A ^ B;
                carry = |(res);
            end
   
            4'b1000: begin // NOT
                res = ~A;
                carry = 0;
            end       
                        
            4'b1001: begin // INC
                temp_result = A + 1'b1;
                res = temp_result[7:0];
                carry = temp_result[8];
            end

            4'b1010: begin // DEC
                temp_result = {1'b0, A} - 1'b1;
                res = temp_result[7:0];
                carry = temp_result[8]; 
            end
            
            4'b1111: begin // XOR fpr BEQ
                res = A ^ B;
                carry = |(res);
            end

            default: begin // Invalid control
                res = 8'h00;
                carry = 0;
            end
        endcase
    end

endmodule


