module ctrl_reg(
        input           clk_i           ,       // ---system  ---
        input           rstn_i          ,

        input   [1:0]   cmd_i           ,       // ---outside ---
        input   [5:0]   cmd_addr_i      ,
        input   [31:0]  cmd_data_i      ,
        output  [31:0]  cmd_data_o      ,

        input   [7:0]   slv0_margin_i   ,       // ---slave ---
        output          slv0_en_o       ,
        input   [7:0]   slv1_margin_i   ,
        output          slv1_en_o       ,
        input   [7:0]   slv2_margin_i   ,
        output          slv2_en_o       ,

        output  [2:0]   slv0_pkglen_o   ,       // ---arbiter ---
        output  [1:0]   slv0_prio_o     ,
        output  [2:0]   slv1_pkglen_o   ,
        output  [1:0]   slv1_prio_o     ,
        output  [2:0]   slv2_pkglen_o   ,
        output  [1:0]   slv2_prio_o      
    );

    reg [31:0] slv0_ctrl_reg;
    reg [31:0] slv1_ctrl_reg;
    reg [31:0] slv2_ctrl_reg;

    assign slv0_en_o = slv0_ctrl_reg[0];
    assign slv1_en_o = slv1_ctrl_reg[0];
    assign slv2_en_o = slv2_ctrl_reg[0];

    assign slv0_prio_o = slv0_ctrl_reg[2:1];
    assign slv1_prio_o = slv1_ctrl_reg[2:1];
    assign slv2_prio_o = slv2_ctrl_reg[2:1];

    assign slv0_pkglen_o = slv0_ctrl_reg[5:3];
    assign slv1_pkglen_o = slv1_ctrl_reg[5:3];
    assign slv2_pkglen_o = slv2_ctrl_reg[5:3];

    reg [31:0] slv0_status_reg;
    reg [31:0] slv1_status_reg;
    reg [31:0] slv2_status_reg;

    reg [31:0] cmd_data_o_r;
    assign cmd_data_o = cmd_data_o_r;

    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            slv0_status_reg <= {24'b0,8'd64};
            slv1_status_reg <= {24'b0,8'd64};
            slv2_status_reg <= {24'b0,8'd64};
        end
        else begin
            slv0_status_reg <= {24'b0,slv0_margin_i};
            slv1_status_reg <= {24'b0,slv1_margin_i};
            slv2_status_reg <= {24'b0,slv2_margin_i};
        end
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i)
            cmd_data_o_r <= 32'd0;
        else if(cmd_i == 2'b01)
            case(cmd_addr_i)
                8'h00 : cmd_data_o_r <= slv0_ctrl_reg;
                8'h04 : cmd_data_o_r <= slv1_ctrl_reg;
                8'h08 : cmd_data_o_r <= slv2_ctrl_reg;
                8'h12 : cmd_data_o_r <= slv0_status_reg;
                8'h16 : cmd_data_o_r <= slv1_status_reg;
                8'h20 : cmd_data_o_r <= slv2_status_reg;
            endcase
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            slv0_ctrl_reg <= 32'b0;
            slv1_ctrl_reg <= 32'b0;
            slv2_ctrl_reg <= 32'b0;
        end
        else if(cmd_i == 2'b10)
            case(cmd_addr_i)
                8'h00 : slv0_ctrl_reg <= {26'b0,cmd_data_i[5:0]};
                8'h04 : slv1_ctrl_reg <= {26'b0,cmd_data_i[5:0]};
                8'h08 : slv2_ctrl_reg <= {26'b0,cmd_data_i[5:0]};
            endcase
    end
endmodule