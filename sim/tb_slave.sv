`timescale 1ns / 1ns

module tb_slave();

    slave u_slave (.*);

    logic          clk_i           ;
    logic          rstn_i          ;

    logic  [31:0]  chx_data_i      ;
    logic          chx_valid_i     ;
    logic          chx_ready_o     ;

    logic          slvx_en_i       ;       // ---register---
    logic  [7:0]   margin_o        ;

    logic  [31:0]  slvx_data_o     ;       // ---Arbiter ---
    logic          slvx_val_o      ;
    logic          slvx_req_o      ;
    logic          a2sx_ack_i      ;
    logic  [31:0]  data0_i         ;

    integer i0 = 0;

    initial
    begin            
        $dumpfile("tb_slave.vcd"); //生成的vcd文件名称
        $dumpvars(0, tb_slave);    //tb模块名称
    end

    always #20 clk_i = ~clk_i;

    initial
    begin            
        clk_i  = 1'b0;
        rstn_i = 1'b0;
        slvx_en_i = 1'b0;
        a2sx_ack_i = 1'b0;
        #120;
        rstn_i = 1'b1;
        #120;
        slvx_en_i = 1'b1;
        #120;
        a2sx_ack_i = 1'b1;
        #120;
        slvx_en_i = 1'b0;
        #360;
        slvx_en_i = 1'b1;
        #360;
        a2sx_ack_i = 1'b0;
        #20000;
        $finish;
    end

    initial begin 
        chx_data_i   = 'd0;
        chx_valid_i  = 1'b0;
        data0_i       = 'h00C0_0000;
        @(posedge rstn_i);
        //#100;
        for(i0 = 0; i0 < 64 ; i0 = i0 + 1)
            ch0_write(data0_i + i0);
        @(negedge clk_i);
        chx_valid_i <= 0;
        chx_data_i <= 0;
    end

    // channel write task
    task ch0_write(input reg[31:0] data); 
        wait(chx_ready_o == 1'b1)
        @(negedge clk_i);
        chx_valid_i <= 1;
        chx_data_i <= data;
    endtask


endmodule