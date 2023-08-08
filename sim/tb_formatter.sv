`timescale 1ns / 1ns

module tb_formatter();

    top_formatter u_top_formatter (.*);

    logic          clk_i           ;
    logic          rstn_i          ;

    logic  [31:0]  ch0_data_i      ;
    logic          ch0_valid_i     ;
    logic          ch0_ready_o     ;

    logic  [31:0]  ch1_data_i      ;
    logic          ch1_valid_i     ;
    logic          ch1_ready_o     ;

    logic  [31:0]  ch2_data_i      ;
    logic          ch2_valid_i     ;
    logic          ch2_ready_o     ;

    logic  [1:0]   cmd_i           ;
    logic  [5:0]   cmd_addr_i      ;
    logic  [31:0]  cmd_data_i      ;
    logic  [31:0]  cmd_data_o      ;

    logic          fmt_req_o       ;
    logic          fmt_grant_i     ;
    logic  [1:0]   fmt_chid_o      ;
    logic  [5:0]   fmt_length_o    ;
    logic  [31:0]  fmt_data_o      ;
    logic          fmt_start_o     ;
    logic          fmt_end_o       ;


    logic [31:0]  data0_i         ;
    logic [31:0]  data1_i         ;
    logic [31:0]  data2_i         ;

initial
begin            
    $dumpfile("tb_formatter.vcd"); //生成的vcd文件名称
    $dumpvars(0, tb_formatter);    //tb模块名称
end

always #20 clk_i = ~clk_i;

initial
begin            
    clk_i  = 1'b0;
    rstn_i = 1'b0;
    fmt_grant_i    = 1'b0;

    cmd_i      = 2'b0;
    cmd_addr_i = 6'b0;
    cmd_data_i = 32'b0;

    #120;
    rstn_i = 1'b1;

    // use task to config
    @(posedge clk_i);
    cmd_i      = 2'b10;
    cmd_addr_i = 8'h00;    
    cmd_data_i = {26'b0,6'b000001};
    @(posedge clk_i);
    cmd_i      = 2'b10;
    cmd_addr_i = 8'h04;    
    cmd_data_i = {26'b0,6'b010001};
    @(posedge clk_i);
    cmd_i      = 2'b10;
    cmd_addr_i = 8'h08;    
    cmd_data_i = {26'b0,6'b011001};
    #20000;
    $finish;
end

integer i0,i1,i2;

initial begin 
    ch0_data_i   = 'd0;
    ch0_valid_i  = 1'b0;
    data0_i       = 'h00C0_0000;
    @(posedge rstn_i);
    #6000;
    for(i0 = 0; i0 < 64 ; i0 = i0 + 1)
        ch0_write(data0_i + i0);
end

initial begin 
    ch1_data_i   = 'd0;
    ch1_valid_i  = 1'b0;
    data1_i       = 'h00C1_0000;
    @(posedge rstn_i);
    #4000;
    for(i1 = 0; i1 < 64 ; i1 = i1 + 1)
        ch1_write(data1_i + i1);
end

initial begin 
    ch2_data_i   = 'd0;
    ch2_valid_i  = 1'b0;
    data2_i       = 'h00C2_0000;
    @(posedge rstn_i);
    #1000;
    // channel 0 test
    for(i2 = 0; i2 < 64 ; i2 = i2 + 1)
        ch2_write(data2_i + i2);
    @(negedge clk_i);
    ch2_valid_i <= 0;
    ch2_data_i <= 0;
end

always begin
    @(posedge fmt_req_o);
    @(negedge clk_i);
    fmt_grant_i    = 1'b1;
    @(negedge clk_i);
    fmt_grant_i    = 1'b0;
end


// channel write task
task ch0_write(input reg[31:0] data); 
    wait(ch0_ready_o == 1'b1)
    @(negedge clk_i);
    ch0_valid_i <= 1;
    ch0_data_i <= data;
    @(negedge clk_i);
    ch0_valid_i <= 0;
    ch0_data_i <= 0;
endtask

task ch1_write(input reg[31:0] data); 
    wait(ch1_ready_o == 1'b1)
    @(negedge clk_i);
    ch1_valid_i <= 1;
    ch1_data_i <= data;
    @(negedge clk_i);
    ch1_valid_i <= 0;
    ch1_data_i <= 0;
endtask

task ch2_write(input reg[31:0] data); 
    wait(ch2_ready_o == 1'b1)
    @(negedge clk_i);
    ch2_valid_i <= 1;
    ch2_data_i <= data;
    // @(negedge clk_i);
    // ch2_valid_i <= 0;
    // ch2_data_i <= 0;
endtask

endmodule