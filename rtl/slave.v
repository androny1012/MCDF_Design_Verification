module slave(
        input           clk_i       ,       // ---system  ---
        input           rstn_i      ,

        input   [31:0]  chx_data_i  ,       // ---outside ---
        input           chx_valid_i ,
        output          chx_ready_o ,

        input           slvx_en_i   ,       // ---register---
        output  [7:0]   margin_o    ,

        output  [31:0]  slvx_data_o ,       // ---Arbiter ---
        output          slvx_val_o  ,
        output          slvx_req_o  ,
        input           a2sx_ack_i
    );

    wire fifo_full;
    wire wr_en;
    wire fifo_empty;
    wire [6:0] fifo_margin;

    reg  slvx_val_o_r;

    assign chx_ready_o = slvx_en_i && !fifo_full;
    assign wr_en = chx_valid_i && chx_ready_o;
    
    //once fifo is not empty, it wants to send data.
    assign slvx_req_o  = !fifo_empty;
    assign slvx_val_o = slvx_val_o_r;
    assign rd_en = a2sx_ack_i && slvx_req_o;
    
    //read fifo need 1 clk
    always @(posedge clk_i or negedge rstn_i) begin
        if(!rstn_i)
            slvx_val_o_r <= 1'b0;
        else if(rd_en)
            slvx_val_o_r <= 1'b1;
        else
            slvx_val_o_r <= 1'b0;
    end

    assign margin_o = fifo_margin;

    FIFO64x32 #(
        .DEPTH      (6              )   ,
        .WIDTH      (32             )   ,
        .MAX_COUNT  (64             )
    )
    u_FIFO64x32 (
        .clk        (clk_i          )   ,
        .rst_n      (rstn_i         )   ,
        .wr_en      (wr_en          )   ,
        .wr_data_i  (chx_data_i     )   ,
        .wr_full    (fifo_full      )   ,
        .rd_en      (rd_en          )   ,
        .rd_data_o  (slvx_data_o    )   ,
        .rd_empty   (fifo_empty     )   ,
        .fifo_margin(fifo_margin    )
    );
endmodule