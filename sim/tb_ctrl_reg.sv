`timescale 1ns / 1ns

module tb_ctrl_reg();

    ctrl_reg u_ctrl_reg (.*);

        logic          clk_i           ;       // ---system  ---
        logic          rstn_i          ;

        logic  [1:0]   cmd_i           ;       // ---outside ---
        logic  [5:0]   cmd_addr_i      ;
        logic  [31:0]  cmd_data_i      ;
        logic  [31:0]  cmd_data_o      ;

        logic  [7:0]   slv0_margin_i   ;       // ---slave ---
        logic          slv0_en_o       ;
        logic  [7:0]   slv1_margin_i   ;
        logic          slv1_en_o       ;
        logic  [7:0]   slv2_margin_i   ;
        logic          slv2_en_o       ;

        logic  [2:0]   slv0_pkglen_o   ;       // ---arbiter ---
        logic  [1:0]   slv0_prio_o     ;
        logic  [2:0]   slv1_pkglen_o   ;
        logic  [1:0]   slv1_prio_o     ;
        logic  [2:0]   slv2_pkglen_o   ;
        logic  [1:0]   slv2_prio_o     ;

initial
begin            
    $dumpfile("tb_ctrl_reg.vcd"); //生成的vcd文件名称
    $dumpvars(0, tb_ctrl_reg);    //tb模块名称
end

always #20 clk_i = ~clk_i;

initial
begin            
    clk_i  = 1'b0;
    rstn_i = 1'b0;

    cmd_i      = 2'b0;
    cmd_addr_i = 6'b0;
    cmd_data_i = 32'b0;

    slv0_margin_i = 6'd10;
    slv1_margin_i = 6'd20;
    slv2_margin_i = 6'd30;
    #120;
    rstn_i = 1'b1;

    // use task to config
    @(negedge clk_i);
    cmd_i      = 2'b10;
    cmd_addr_i = 8'h00;    
    cmd_data_i = {26'b0,6'b000001};
    @(negedge clk_i);
    cmd_i      = 2'b10;
    cmd_addr_i = 8'h04;    
    cmd_data_i = {26'b0,6'b010011};
    @(negedge clk_i);
    cmd_i      = 2'b10;
    cmd_addr_i = 8'h08;    
    cmd_data_i = {26'b0,6'b011111};

    @(negedge clk_i);
    cmd_i      = 2'b00;
    cmd_addr_i = 8'h00;    

    @(negedge clk_i);
    cmd_i      = 2'b10;
    cmd_addr_i = 8'h00;    
    cmd_data_i = {26'b0,6'b111111};

    @(negedge clk_i);
    cmd_i      = 2'b01;
    cmd_addr_i = 8'h00;    
    @(negedge clk_i);
    cmd_i      = 2'b01;
    cmd_addr_i = 8'h04;    
    @(negedge clk_i);
    cmd_i      = 2'b01;
    cmd_addr_i = 8'h08;
    @(negedge clk_i);
    cmd_i      = 2'b01;
    cmd_addr_i = 8'h12;    
    @(negedge clk_i);
    cmd_i      = 2'b01;
    cmd_addr_i = 8'h16;    
    @(negedge clk_i);
    cmd_i      = 2'b01;
    cmd_addr_i = 8'h20;    
    #20000;
    $finish;
end


endmodule