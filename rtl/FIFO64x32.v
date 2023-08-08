module FIFO64x32 #(
        parameter DEPTH         = 6 ,
        parameter WIDTH         = 32,
        parameter MAX_COUNT     = (1<<DEPTH)
    )(
        input                   clk         ,       // ---system---
        input                   rst_n       ,

        input                   wr_en       ,       // ---write ---
        input   [WIDTH-1:0]     wr_data_i   ,
        output                  wr_full     ,

        input                   rd_en       ,       // ---read  ---
        output  [WIDTH-1:0]     rd_data_o   ,
        output                  rd_empty    ,

        output  [DEPTH:0]       fifo_margin
    );

    reg  [DEPTH-1 : 0] wr_bin;
    reg  [DEPTH-1 : 0] rd_bin;
    reg  [DEPTH-1 : 0] count ;
    wire wr_full ;
    wire rd_empty;

    reg  [WIDTH-1 : 0]  fifomem [MAX_COUNT - 1 : 0]; 

    wire                fifo_wr_en      ;
    wire [DEPTH-1:0]    fifo_wr_addr    ;
    wire [WIDTH-1:0]    fifo_data_w     ;

    wire                fifo_rd_en      ;
    wire [DEPTH-1:0]    fifo_rd_addr    ;
    reg  [WIDTH-1:0]    fifo_data_r     ;

    // ******************************** Write ******************************* //
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wr_bin <= 'b0;
        else if (fifo_wr_en)
            wr_bin <= wr_bin + 1'b1;
    end

    // ******************************** Read ******************************** //
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rd_bin <= 'b0;
        else if (fifo_rd_en)
            rd_bin <= rd_bin + 1'b1;
    end

    // ******************************** PTR  ******************************** //
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            count <= 0;
        else
            case({fifo_rd_en,fifo_wr_en})
                2'b00: count <= count;
                2'b01: count <= count + 1'b1;
                2'b10: count <= count - 1'b1;
                2'b11: count <= count;
                default: count <= 'bx;
            endcase    
    end
    assign fifo_margin = MAX_COUNT - count;

    assign wr_full  = (count == MAX_COUNT - 1'b1);
    assign rd_empty = (count == 'b0 );

    // ******************************** FIFOMEM ******************************** //

    assign fifo_wr_en   = wr_en;
    assign fifo_data_w  = wr_data_i;
    assign fifo_wr_addr = wr_bin;

    assign fifo_rd_en   = rd_en;
    assign rd_data_o    = fifo_data_r;
    assign fifo_rd_addr = rd_bin;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            fifo_data_r <= 'd0;
        else if(fifo_rd_en)
            fifo_data_r <= fifomem[fifo_rd_addr];
    end 

    always @(posedge clk) begin
        if(fifo_wr_en)
            fifomem[fifo_wr_addr] <= fifo_data_w;
    end

endmodule