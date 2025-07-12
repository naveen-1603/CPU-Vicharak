module CPU_Top(
    input CLK, RESET
    );
    
    wire pc_en;
    wire [7:0]pc_ld;
    wire [7:0]pc_addr;
    wire      pc_ld_en;
    
    wire [18:0]inst;
    wire zero;
    wire mux_sel;
    
    wire [3:0]alu_ctrl;
    wire [7:0]res;
   
    wire       reg_wrt_en;
    wire [3:0] reg_wrt;
    wire [3:0] reg_rd1;
    wire [3:0] reg_rd2;
    wire [7:0] rd1_dat;
    wire [7:0] rd2_dat;
    wire [7:0] wrt_dat;
    
    wire [7:0] mem_rd_data;
    wire       mem_wrt_en;
    wire [7:0] mem_wrt_data;
    wire [7:0] mem_addr;
    
    
    
    PC pc_unit (
        .CLK(CLK),
        .RESET(RESET),
        .pc_en(pc_en),
        .pc_ld(pc_ld),
        .pc_ld_en(pc_ld_en),
        .address(pc_addr)
    );
    
    IM im_unit (
        .in_addr(pc_addr),
        .inst(inst)
    );
    
    ID id_unit (
        .CLK(CLK),
        .RESET(RESET),
        .inst(inst),
        .pc_addr(pc_addr),
        .reg2_data(rd2_dat),
        .reg1_data(rd1_dat),
        .mem_rd_data(mem_rd_data),
        .zero(zero),
        .pc_en(pc_en),
        .pc_ld(pc_ld),
        .pc_ld_en(pc_ld_en),
        .alu_ctrl(alu_ctrl),
        .mem_wrt_en(mem_wrt_en),
        .mem_wrt_data(mem_wrt_data),
        .mem_addr(mem_addr),
        .reg_wrt_en(reg_wrt_en),
        .reg_wrt(reg_wrt),
        .reg_rd1(reg_rd1),
        .reg_rd2(reg_rd2),
        .mux_sel(mux_sel)
    );
    
    ALU alu_unit (
        .A(rd1_dat),
        .B(rd2_dat),
        .ALU_ctrl(alu_ctrl),
        .res(res),
        .carry(zero)
    );
    
    DM dm_unit (
        .CLK(CLK),
        .address(mem_addr),
        .wrt_data(mem_wrt_data),
        .rd_data(mem_rd_data),
        .wrt_en(mem_wrt_en)
    );
    
    RF rf_unit (
        .CLK(CLK),
        .wrt_en(reg_wrt_en),
        .wrt_dat(wrt_dat),
        .reg_wrt(reg_wrt),
        .reg_rd2(reg_rd2),
        .rd2_dat(rd2_dat),
        .rd1_dat(rd1_dat),
        .reg_rd1(reg_rd1)
    );
    
    assign wrt_dat = (mux_sel) ? mem_rd_data : res ;
    
endmodule
