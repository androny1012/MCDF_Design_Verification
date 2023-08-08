module top_arbiter(
        input           clk_i           ,       // ---system  ---
        input           rstn_i          ,

        input   [31:0]  ch0_data_i      ,       // ---ch0 ---
        input           ch0_valid_i     ,
        output          ch0_ready_o     ,

        input   [31:0]  ch1_data_i      ,       // ---ch1 ---
        input           ch1_valid_i     ,
        output          ch1_ready_o     ,

        input   [31:0]  ch2_data_i      ,       // ---ch2 ---
        input           ch2_valid_i     ,
        output          ch2_ready_o     ,

        input           f2a_id_req_i    ,       // ---formatter ---
        input           f2a_ack_i       ,
        output          a2f_val_o       ,
        output  [1:0]   a2f_id_o        ,
        output  [31:0]  a2f_data_o      ,
        output  [2:0]   a2f_pkglen_sel_o
    );

        //prio/pkglen from register

        wire          slv0_en_i;
        assign slv0_en_i = 1'b1;
        wire  [7:0]   margin0_o;
        wire  [1:0]   slv0_prio_i       ;       // ---slv0 ---
        assign slv0_prio_i = 2'd2;
        wire  [2:0]   slv0_pkglen_i     ;
        assign slv0_pkglen_i = 3'd3;
        wire  [31:0]  slv0_data         ;
        wire          slv0_req          ;
        wire          slv0_val          ;
        wire          a2s0_ack          ;

        wire          slv1_en_i;
        assign slv1_en_i = 1'b1;
        wire  [7:0]   margin1_o;
        wire  [1:0]   slv1_prio_i       ;       // ---slv1 ---
        assign slv1_prio_i = 2'd1;
        wire  [2:0]   slv1_pkglen_i     ;
        assign slv1_pkglen_i = 3'd2;
        wire  [31:0]  slv1_data         ;
        wire          slv1_req          ;
        wire          slv1_val          ;
        wire          a2s1_ack          ;

        wire          slv2_en_i;
        assign slv2_en_i = 1'b1;
        wire  [7:0]   margin2_o;
        wire  [1:0]   slv2_prio_i       ;       // ---slv2 ---
        assign slv2_prio_i = 2'd1;
        wire  [2:0]   slv2_pkglen_i     ;
        assign slv2_pkglen_i = 3'd1;
        wire  [31:0]  slv2_data         ;
        wire          slv2_req          ;
        wire          slv2_val          ;
        wire          a2s2_ack          ;    

        slave u_slv0(
            .clk_i      (clk_i      ) ,       // ---system  ---
            .rstn_i     (rstn_i     ) ,

            .chx_data_i (ch0_data_i ) ,       // ---outside ---
            .chx_valid_i(ch0_valid_i) ,
            .chx_ready_o(ch0_ready_o) ,

            .slvx_en_i  (slv0_en_i  ) ,       // ---register---
            .margin_o   (margin0_o   ) ,

            .slvx_data_o(slv0_data  ) ,       // ---Arbiter ---
            .slvx_val_o (slv0_val   ) ,
            .slvx_req_o (slv0_req   ) ,
            .a2sx_ack_i (a2s0_ack   ) 
        );

        slave u_slv1(
            .clk_i      (clk_i      ) ,       // ---system  ---
            .rstn_i     (rstn_i     ) ,

            .chx_data_i (ch1_data_i ) ,       // ---outside ---
            .chx_valid_i(ch1_valid_i) ,
            .chx_ready_o(ch1_ready_o) ,

            .slvx_en_i  (slv1_en_i  ) ,       // ---register---
            .margin_o   (margin1_o   ) ,

            .slvx_data_o(slv1_data  ) ,       // ---Arbiter ---
            .slvx_val_o (slv1_val   ) ,
            .slvx_req_o (slv1_req   ) ,
            .a2sx_ack_i (a2s1_ack   ) 
        );

        slave u_slv2(
            .clk_i      (clk_i      ) ,       // ---system  ---
            .rstn_i     (rstn_i     ) ,

            .chx_data_i (ch2_data_i ) ,       // ---outside ---
            .chx_valid_i(ch2_valid_i) ,
            .chx_ready_o(ch2_ready_o) ,

            .slvx_en_i  (slv2_en_i  ) ,       // ---register---
            .margin_o   (margin2_o   ) ,

            .slvx_data_o(slv2_data  ) ,       // ---Arbiter ---
            .slvx_val_o (slv2_val   ) ,
            .slvx_req_o (slv2_req   ) ,
            .a2sx_ack_i (a2s2_ack   ) 
        );

        arbiter u_arbiter(
            .clk_i            (clk_i           ),       // ---system  ---
            .rstn_i           (rstn_i          ),

            .slv0_prio_i      (slv0_prio_i     ),       // ---slv0 ---
            .slv0_pkglen_i    (slv0_pkglen_i   ),
            .slv0_data_i      (slv0_data       ),
            .slv0_req_i       (slv0_req        ),
            .slv0_val_i       (slv0_val        ),
            .a2s0_ack_o       (a2s0_ack        ),

            .slv1_prio_i      (slv1_prio_i     ),       // ---slv1 ---
            .slv1_pkglen_i    (slv1_pkglen_i   ),
            .slv1_data_i      (slv1_data       ),
            .slv1_req_i       (slv1_req        ),
            .slv1_val_i       (slv1_val        ),
            .a2s1_ack_o       (a2s1_ack        ),

            .slv2_prio_i      (slv2_prio_i     ),       // ---slv2 ---
            .slv2_pkglen_i    (slv2_pkglen_i   ),
            .slv2_data_i      (slv2_data       ),
            .slv2_req_i       (slv2_req        ),
            .slv2_val_i       (slv2_val        ),
            .a2s2_ack_o       (a2s2_ack        ),

            .f2a_id_req_i     (f2a_id_req_i    ),       // ---formatter ---
            .f2a_ack_i        (f2a_ack_i       ),
            .a2f_val_o        (a2f_val_o       ),
            .a2f_id_o         (a2f_id_o        ),
            .a2f_data_o       (a2f_data_o      ),
            .a2f_pkglen_sel_o (a2f_pkglen_sel_o)
        );
endmodule