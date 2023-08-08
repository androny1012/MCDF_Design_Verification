module formatter(
        input           clk_i           ,       // ---system  ---
        input           rstn_i          ,

        output          f2a_ack_o       ,       // ---arbiter ---
        output          fmt_id_req_o    ,
        input           a2f_val_i       ,
        input   [1:0]   a2f_id_i        ,
        input   [31:0]  a2f_data_i      ,
        input   [2:0]   pkglen_sel_i    ,

        output          fmt_req_o       ,       // ---outside ---
        input           fmt_grant_i     ,

        output  [1:0]   fmt_chid_o      ,
        output  [5:0]   fmt_length_o    ,
        output  [31:0]  fmt_data_o      ,
        output          fmt_start_o     ,
        output          fmt_end_o        
    );

    reg [31:0]  mem [31:0];

    reg [5:0]   pkglen          ;
    reg [5:0]   pkglen_out      ;
    assign pkglen_out = fmt_length_o;
    reg [5:0]   pkg_count       ;

    reg [5:0]   recv_count      ;

    reg         f2a_ack_r       ;
    reg         fmt_id_req_r    ;
    reg         fmt_id_req_r2   ;
    reg         fmt_id_req_neg   ;
    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            fmt_id_req_r2 <= 1'b0;
        else
            fmt_id_req_r2 <= fmt_id_req_r;
    end
    assign fmt_id_req_neg = !fmt_id_req_r && fmt_id_req_r2;
    
    assign f2a_ack_o = f2a_ack_r && !(a2f_val_i && recv_count == pkglen - 1'b1);
    assign fmt_id_req_o = fmt_id_req_r;


    reg         id_req_r;
    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            id_req_r <= 1'b0;
        else if(fmt_id_req_r)
            id_req_r <= 1'b1;
        else if(fmt_grant_i && fmt_req_r)
            id_req_r <= 1'b0;
    end    
    reg         fmt_req_r       ;
    reg [1:0]   fmt_chid_r      ;
    reg [5:0]   fmt_length_r    ;
    reg [31:0]  fmt_data_r      ;
    reg         fmt_start_r     ;
    reg         fmt_end_r       ;
    
    assign fmt_req_o    = fmt_req_r       ;
    assign fmt_chid_o   = fmt_chid_r      ;
    assign fmt_length_o = fmt_length_r    ;
    assign fmt_data_o   = fmt_data_r      ;
    assign fmt_start_o  = fmt_start_r     ;
    assign fmt_end_o    = fmt_end_r       ;

    reg         sending_flag    ;
    reg [1:0]   ram_status      ;
    reg         fmt_rd_en       ;
    wire        ram_rd_en       ;

    reg         fmt_grant_r     ;
    wire        fmt_grant_pos   ;

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            fmt_grant_r <= 1'b0;
        else
            fmt_grant_r <= fmt_grant_i;
    end
    assign fmt_grant_pos = fmt_grant_i && !fmt_grant_r;
    assign ram_rd_en = fmt_rd_en | fmt_grant_pos;
    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i)
            fmt_data_r <= 32'b0;
        else if(ram_rd_en)
            fmt_data_r <= mem[pkg_count];
    end 

    always @(posedge clk_i) begin
        if(a2f_val_i)
            mem[recv_count] <= a2f_data_i;
    end

    always @(*) begin
        if(pkglen_sel_i == 3'd0)        pkglen = 6'd4;
        else if(pkglen_sel_i == 3'd1)   pkglen = 6'd8;
        else if(pkglen_sel_i == 3'd2)   pkglen = 6'd16;
        else if(pkglen_sel_i == 3'd3)   pkglen = 6'd32;
        else                            pkglen = 6'd32;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            pkg_count <= 6'b0;
        else if(ram_rd_en)
            pkg_count <= pkg_count + 1'b1;
        else
            pkg_count <= 6'b0; // it must be continuous
    end
   
    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            recv_count <= 6'b0;
        else if(a2f_val_i && recv_count == pkglen - 1'b1)
            recv_count <= 6'b0;
        else if(a2f_val_i)
            recv_count <= recv_count + 1'b1;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            fmt_id_req_r <= 1'b1;
        else if(fmt_grant_i && fmt_req_r)
            fmt_id_req_r <= 1'b1;
        else if(a2f_id_i != 2'd3 && id_req_r)
            fmt_id_req_r <= 1'b0;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            f2a_ack_r <= 1'b0;
        else if(a2f_val_i && recv_count == pkglen - 1'b1)
            f2a_ack_r <= 1'b0;
        // else if(fmt_grant_i && fmt_req_r)
        //     f2a_ack_r <= 1'b1;
        else if(fmt_id_req_neg)
            f2a_ack_r <= 1'b1;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            ram_status <= 2'b0;
        else if(a2f_val_i && recv_count == pkglen - 1'b1)
            ram_status <= ram_status + 1'b1;
        else if(fmt_end_r)
            ram_status <= ram_status - 1'b1;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            fmt_req_r <= 1'b0;
        else if(fmt_grant_i && fmt_req_r)
            fmt_req_r <= 1'b0;
        else if(ram_status != 2'b0 && !sending_flag)
            fmt_req_r <= 1'b1;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            sending_flag <= 1'b0;
        else if(fmt_grant_i && fmt_req_r)
            sending_flag <= 1'b1;
        else if(fmt_end_r)
            sending_flag <= 1'b0;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i) begin
            fmt_chid_r = 2'd3;
            fmt_length_r = 6'd0;
        end
        else if(ram_status != 2'b0 && !sending_flag) begin
            fmt_chid_r = a2f_id_i;
            fmt_length_r = pkglen;
        end
        else if(fmt_end_r)begin
            fmt_chid_r = 2'd3;
            fmt_length_r = 6'd0;
        end
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            fmt_start_r <= 1'b0;
        else if(fmt_grant_i && fmt_req_r)
            fmt_start_r <= 1'b1;
        else
            fmt_start_r <= 1'b0;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            fmt_rd_en <= 1'b0;
        else if(fmt_grant_i && fmt_req_r)
            fmt_rd_en <= 1'b1;
        else if(pkg_count == pkglen_out - 1'b1)
            fmt_rd_en <= 1'b0;
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            fmt_end_r <= 1'b0;
        else if(pkg_count == pkglen_out - 1'b1)
            fmt_end_r <= 1'b1;
        else
            fmt_end_r <= 1'b0;
    end

endmodule