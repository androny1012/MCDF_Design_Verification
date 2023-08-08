module arbiter(
        input           clk_i           ,       // ---system  ---
        input           rstn_i          ,

        input   [1:0]   slv0_prio_i     ,       // ---slv0 ---
        input   [2:0]   slv0_pkglen_i   ,
        input   [31:0]  slv0_data_i     ,
        input           slv0_req_i      ,
        input           slv0_val_i      ,
        output          a2s0_ack_o      ,

        input   [1:0]   slv1_prio_i     ,       // ---slv1 ---
        input   [2:0]   slv1_pkglen_i   ,
        input   [31:0]  slv1_data_i     ,
        input           slv1_req_i      ,
        input           slv1_val_i      ,
        output          a2s1_ack_o      ,

        input   [1:0]   slv2_prio_i     ,       // ---slv2 ---
        input   [2:0]   slv2_pkglen_i   ,
        input   [31:0]  slv2_data_i     ,
        input           slv2_req_i      ,
        input           slv2_val_i      ,
        output          a2s2_ack_o      ,

        input           f2a_id_req_i    ,       // ---formatter ---
        input           f2a_ack_i       ,
        output          a2f_val_o       ,
        output  [1:0]   a2f_id_o        ,
        output  [31:0]  a2f_data_o      ,
        output  [2:0]   a2f_pkglen_sel_o
    );

    //careful to judge id twice, how to call this
    // reg         f2a_id_req_r    ;
    // wire        f2a_id_req_real ;
    // always @(posedge clk_i or negedge rstn_i) begin
    //     if(!rstn_i)
    //         f2a_id_req_r <= 1'b0;
    //     else
    //         f2a_id_req_r <= f2a_id_req_i;
    // end
    // assign f2a_id_req_real = f2a_id_req_i && f2a_id_req_r;

    reg  [1:0]      arbiter_result;

    wire [2:0]      req;
    assign req      = {slv2_req_i,slv1_req_i,slv0_req_i};
    wire [11:0]     pkglen;
    assign pkglen   = {3'b0,slv2_pkglen_i,slv1_pkglen_i,slv0_pkglen_i};
    wire [127:0]    data;
    assign data     = {32'b0,slv2_data_i,slv1_data_i,slv0_data_i};
    wire [3:0]      val;
    assign val      = {1'b0,slv2_val_i,slv1_val_i,slv0_val_i};

    assign a2f_val_o        = val[arbiter_result];
    assign a2f_id_o         = arbiter_result;
    assign a2f_data_o       = data[arbiter_result*32+:32];
    assign a2f_pkglen_sel_o = pkglen[arbiter_result*3+:3];

    assign a2s0_ack_o = (arbiter_result == 2'd0) ? f2a_ack_i : 1'b0;
    assign a2s1_ack_o = (arbiter_result == 2'd1) ? f2a_ack_i : 1'b0;
    assign a2s2_ack_o = (arbiter_result == 2'd2) ? f2a_ack_i : 1'b0;

    wire [1:0] min_index;
    min u_min(
        .slv0_prio_i(slv0_prio_i), 
        .slv1_prio_i(slv1_prio_i), 
        .slv2_prio_i(slv2_prio_i), 
        .min_index(min_index)
    );

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i) begin
            arbiter_result <= 2'b11;
        end
        else if(f2a_id_req_i) //只有formatter发起一次传输时才改变id,输入的req应该保持?(不空就会保持)
            if(req == 3'b000)
                arbiter_result <= 2'd3;
            else if(req == 3'b001)
                arbiter_result <= 2'd0;
            else if(req == 3'b010)
                arbiter_result <= 2'd1;
            else if(req == 3'b100)
                arbiter_result <= 2'd2;
            else if(req == 3'b011)
                arbiter_result <= (slv1_prio_i < slv0_prio_i) ? 2'd1 : 2'd0;
            else if(req == 3'b101)
                arbiter_result <= (slv2_prio_i < slv0_prio_i) ? 2'd2 : 2'd0;
            else if(req == 3'b110)
                arbiter_result <= (slv2_prio_i < slv1_prio_i) ? 2'd2 : 2'd1;
            else if(req == 3'b111)
                arbiter_result <= min_index;
    end

endmodule