module top_formatter(
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

        input   [1:0]   cmd_i           ,       // ---ctrl_reg ---
        input   [5:0]   cmd_addr_i      ,
        input   [31:0]  cmd_data_i      ,
        output  [31:0]  cmd_data_o      ,

        output          fmt_req_o       ,       // ---outside ---
        input           fmt_grant_i     ,

        output  [1:0]   fmt_chid_o      ,
        output  [5:0]   fmt_length_o    ,
        output  [31:0]  fmt_data_o      ,
        output          fmt_start_o     ,
        output          fmt_end_o       
    );

        //prio/pkglen from register

        wire          slv0_en           ;
        wire  [7:0]   slv0_margin       ;
        wire  [1:0]   slv0_prio         ;       // ---slv0 ---
        wire  [2:0]   slv0_pkglen       ;
        wire  [31:0]  slv0_data         ;
        wire          slv0_req          ;
        wire          slv0_val          ;
        wire          a2s0_ack          ;

        wire          slv1_en           ;
        wire  [7:0]   slv1_margin       ;
        wire  [1:0]   slv1_prio         ;       // ---slv1 ---
        wire  [2:0]   slv1_pkglen       ;
        wire  [31:0]  slv1_data         ;
        wire          slv1_req          ;
        wire          slv1_val          ;
        wire          a2s1_ack          ;

        wire          slv2_en           ;
        wire  [7:0]   slv2_margin       ;
        wire  [1:0]   slv2_prio         ;       // ---slv2 ---
        wire  [2:0]   slv2_pkglen       ;
        wire  [31:0]  slv2_data         ;
        wire          slv2_req          ;
        wire          slv2_val          ;
        wire          a2s2_ack          ;    


        wire          f2a_id_req_i      ;       // ---formatter ---
        wire          f2a_ack_i         ;
        wire          a2f_val_o         ;
        wire  [1:0]   a2f_id_o          ;
        wire  [31:0]  a2f_data_o        ;
        wire  [2:0]   a2f_pkglen_sel_o  ;
    
        slave u_slv0(
            .clk_i      (clk_i      ) ,       // ---system  ---
            .rstn_i     (rstn_i     ) ,

            .chx_data_i (ch0_data_i ) ,       // ---outside ---
            .chx_valid_i(ch0_valid_i) ,
            .chx_ready_o(ch0_ready_o) ,

            .slvx_en_i  (slv0_en    ) ,       // ---register---
            .margin_o   (slv0_margin) ,

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

            .slvx_en_i  (slv1_en    ) ,       // ---register---
            .margin_o   (slv1_margin) ,

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

            .slvx_en_i  (slv2_en    ) ,       // ---register---
            .margin_o   (slv2_margin) ,

            .slvx_data_o(slv2_data  ) ,       // ---Arbiter ---
            .slvx_val_o (slv2_val   ) ,
            .slvx_req_o (slv2_req   ) ,
            .a2sx_ack_i (a2s2_ack   ) 
        );

        arbiter u_arbiter(
            .clk_i            (clk_i           ),       // ---system  ---
            .rstn_i           (rstn_i          ),

            .slv0_prio_i      (slv0_prio       ),       // ---slv0 ---
            .slv0_pkglen_i    (slv0_pkglen     ),
            .slv0_data_i      (slv0_data       ),
            .slv0_req_i       (slv0_req        ),
            .slv0_val_i       (slv0_val        ),
            .a2s0_ack_o       (a2s0_ack        ),

            .slv1_prio_i      (slv1_prio       ),       // ---slv1 ---
            .slv1_pkglen_i    (slv1_pkglen     ),
            .slv1_data_i      (slv1_data       ),
            .slv1_req_i       (slv1_req        ),
            .slv1_val_i       (slv1_val        ),
            .a2s1_ack_o       (a2s1_ack        ),

            .slv2_prio_i      (slv2_prio       ),       // ---slv2 ---
            .slv2_pkglen_i    (slv2_pkglen     ),
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

        ctrl_reg u_ctrl_reg(
            .clk_i        (clk_i        )   ,       // ---system  ---
            .rstn_i       (rstn_i       )   ,

            .cmd_i        (cmd_i        )   ,       // ---outside ---
            .cmd_addr_i   (cmd_addr_i   )   ,
            .cmd_data_i   (cmd_data_i   )   ,
            .cmd_data_o   (cmd_data_o   )   ,

            .slv0_margin_i(slv0_margin  )   ,       // ---slave ---
            .slv0_en_o    (slv0_en      )   ,
            .slv1_margin_i(slv1_margin  )   ,
            .slv1_en_o    (slv1_en      )   ,
            .slv2_margin_i(slv2_margin  )   ,
            .slv2_en_o    (slv2_en      )   ,

            .slv0_pkglen_o(slv0_pkglen  )   ,       // ---arbiter ---
            .slv0_prio_o  (slv0_prio    )   ,
            .slv1_pkglen_o(slv1_pkglen  )   ,
            .slv1_prio_o  (slv1_prio    )   ,
            .slv2_pkglen_o(slv2_pkglen  )   ,
            .slv2_prio_o  (slv2_prio    )    
    );

        formatter u_formatter(
            .clk_i          (clk_i             )    ,       // ---system  ---
            .rstn_i         (rstn_i            )    ,

            .f2a_ack_o      (f2a_ack_i         )    ,       // ---arbiter ---
            .fmt_id_req_o   (f2a_id_req_i      )    ,
            .a2f_val_i      (a2f_val_o         )    ,
            .a2f_id_i       (a2f_id_o          )    ,
            .a2f_data_i     (a2f_data_o        )    ,
            .pkglen_sel_i   (a2f_pkglen_sel_o  )    ,

            .fmt_req_o      (fmt_req_o         )    ,       // ---outside ---
            .fmt_grant_i    (fmt_grant_i       )    ,

            .fmt_chid_o     (fmt_chid_o        )    ,
            .fmt_length_o   (fmt_length_o      )    ,
            .fmt_data_o     (fmt_data_o        )    ,
            .fmt_start_o    (fmt_start_o       )    ,
            .fmt_end_o      (fmt_end_o         )     
    );
endmodule