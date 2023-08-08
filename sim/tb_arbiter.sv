`timescale 1ns / 1ns

module tb_arbiter();

    top_arbiter u_top_arbiter (.*);

    logic         clk_i           ;       // ---system  ---
    logic         rstn_i          ;

    logic [31:0]  ch0_data_i      ;       // ---ch0 ---
    logic         ch0_valid_i     ;
    logic         ch0_ready_o     ;

    logic [31:0]  ch1_data_i      ;       // ---ch1 ---
    logic         ch1_valid_i     ;
    logic         ch1_ready_o     ;

    logic [31:0]  ch2_data_i      ;       // ---ch2 ---
    logic         ch2_valid_i     ;
    logic         ch2_ready_o     ;

    logic         f2a_id_req_i    ;       // ---formatter ---
    logic         f2a_ack_i       ;
    logic         a2f_val_o       ;
    logic [1:0]   a2f_id_o        ;
    logic [31:0]  a2f_data_o      ;
    logic [2:0]   a2f_pkglen_sel_o;


    logic [31:0]  data0_i         ;
    logic [31:0]  data1_i         ;
    logic [31:0]  data2_i         ;

initial
begin            
    $dumpfile("tb_arbiter.vcd"); //生成的vcd文件名称
    $dumpvars(0, tb_arbiter);    //tb模块名称
end

always #20 clk_i = ~clk_i;

initial
begin            
    clk_i  = 1'b0;
    rstn_i = 1'b0;

    #120;
    rstn_i = 1'b1;
end

integer i0,i1,i2;

initial begin 
    ch0_data_i   = 'd0;
    ch0_valid_i  = 1'b0;
    data0_i       = 'h00C0_0000;
    @(posedge rstn_i);
    #600;
    for(i0 = 0; i0 < 70 ; i0 = i0 + 1)
        ch0_write(data0_i + i0);
end

initial begin 
    ch1_data_i   = 'd0;
    ch1_valid_i  = 1'b0;
    data1_i       = 'h00C1_0000;
    @(posedge rstn_i);
    #400;
    for(i1 = 0; i1 < 70 ; i1 = i1 + 1)
        ch1_write(data1_i + i1);
end

initial begin 
    ch2_data_i   = 'd0;
    ch2_valid_i  = 1'b0;
    data2_i       = 'h00C2_0000;
    @(posedge rstn_i);
    #1000;
    // channel 0 test
    for(i2 = 0; i2 < 70 ; i2 = i2 + 1)
        ch2_write(data2_i + i2);
end

initial begin 
    f2a_ack_i    = 1'b0;
    f2a_id_req_i = 1'b0; 

    @(posedge rstn_i);
    #200;
    f2a_ack_i    = 1'b1;
    @(negedge clk_i);
    f2a_id_req_i = 1'b1;
    #80;
    f2a_id_req_i = 1'b0;
    #240;
    @(negedge clk_i);
    f2a_id_req_i = 1'b1;    
    #80;
    f2a_id_req_i = 1'b0;
    #220;
    @(negedge clk_i);
    f2a_id_req_i = 1'b1;    
    #80;
    f2a_id_req_i = 1'b0;
    #220;
    @(negedge clk_i);
    f2a_id_req_i = 1'b1;    
    #80;
    f2a_id_req_i = 1'b0;
    #2000;
    $finish;
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
    @(negedge clk_i);
    ch2_valid_i <= 0;
    ch2_data_i <= 0;
endtask

endmodule