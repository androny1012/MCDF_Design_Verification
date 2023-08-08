module min(
        input   [1:0]   slv0_prio_i     , 
        input   [1:0]   slv1_prio_i     , 
        input   [1:0]   slv2_prio_i     , 
        output  [1:0]   min_index
    );

    assign min_index = min({slv0_prio_i,slv1_prio_i,slv2_prio_i});

    function [1:0] min;
        input [6:0] x;
        reg  [1:0] min_value;
        integer i;
        begin
            min_value = 2'b11;
            for (i = 0; i < 3; i = i + 1)
                if (x[i*2+:2] <= min_value) begin
                    min_value = x[i*2+:2];
                    min = 2-i;
                end
        end
    endfunction

endmodule
