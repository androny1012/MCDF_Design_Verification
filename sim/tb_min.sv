`timescale 1ns / 1ns

module tb_min();

    min u_min (.*);

logic [1:0]   slv0_prio_i;
logic [1:0]   slv1_prio_i;  
logic [1:0]   slv2_prio_i;  
logic [1:0]   min_index  ;

    initial
    begin            
        $dumpfile("tb_min.vcd"); //生成的vcd文件名称
        $dumpvars(0, tb_min);    //tb模块名称
    end

    initial begin
        slv0_prio_i = 2'd3;
        slv1_prio_i = 2'd1;
        slv2_prio_i = 2'd2;

        #2;
        slv0_prio_i = 2'd3;
        slv1_prio_i = 2'd2;
        slv2_prio_i = 2'd1;

        #2;
        slv0_prio_i = 2'd2;
        slv1_prio_i = 2'd3;
        slv2_prio_i = 2'd1;

        #2;
        slv0_prio_i = 2'd1;
        slv1_prio_i = 2'd3;
        slv2_prio_i = 2'd2;

        #2;
        slv0_prio_i = 2'd2;
        slv1_prio_i = 2'd1;
        slv2_prio_i = 2'd3;

        #2;
        slv0_prio_i = 2'd1;
        slv1_prio_i = 2'd2;
        slv2_prio_i = 2'd3;

        #2;
        slv0_prio_i = 2'd1;
        slv1_prio_i = 2'd1;
        slv2_prio_i = 2'd3;

        #2;
        slv0_prio_i = 2'd2;
        slv1_prio_i = 2'd2;
        slv2_prio_i = 2'd1;

        #2;
        slv0_prio_i = 2'd1;
        slv1_prio_i = 2'd2;
        slv2_prio_i = 2'd1;

        #2;
        slv0_prio_i = 2'd2;
        slv1_prio_i = 2'd1;
        slv2_prio_i = 2'd2;

        #2;
        slv0_prio_i = 2'd1;
        slv1_prio_i = 2'd2;
        slv2_prio_i = 2'd2;

        #2;
        slv0_prio_i = 2'd3;
        slv1_prio_i = 2'd2;
        slv2_prio_i = 2'd2;

        #2;
        slv0_prio_i = 2'd2;
        slv1_prio_i = 2'd2;
        slv2_prio_i = 2'd2;

        #2;
    end

endmodule