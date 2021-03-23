module communication(
    input clock_in,
    input txe_n,
    input enable,
    output [7:0]data_out,
    output wr_n
);




assign data_to_send = 1'b1;


wire [7:0]lfsrParallelOut;

reg one = 1'b1;

fifoTx fifoTx0(
    .clock_in(clock_in),
    .txe_n(txe_n),
    .data_out(data_out),
    .wr_n(wr_n),

    .data_in(lfsrParallelOut),
    .clock_out(lfsr_clock),
    .data_to_send(enable),
    .transfer_on(transfer_going)

);


    

gen_lfsr gen0(
    .clock(lfsr_clock),
    .data(lfsr_data)
);



serPar serPar0(
    .din(lfsr_data),
    .clk(lfsr_clock),
    .sw(one),
    .dout(lfsrParallelOut)
);

endmodule


module serPar(  
    input din,  
    input clk,
    input sw,  
    output [7:0] dout
    );  
wire [7:0] ic;

assign dout = ic;
FFn F0(din, clk, ic[0]),  
F1(ic[0], clk, ic[1]),  
F2(ic[1], clk, ic[2]),  
F3(ic[2], clk, ic[3]),  
F4(ic[3], clk, ic[4]),
F5(ic[4], clk, ic[5]),  
F6(ic[5], clk, ic[6]),  
F7(ic[6], clk, ic[7]);

endmodule


module gen_lfsr(
    input clock,
    output data
);

wire [3:0] ic;
wire din;
wire data;
assign din = ic[3] ^ ic[2];
assign data = ic[3];
FF F0(din, clock, ic[0]),  
F1(ic[0], clock, ic[1]),  
F2(ic[1], clock, ic[2]); 

FF1 F3(ic[2], clock, ic[3]);

endmodule

module FFn(
    input d,
    input c,
    output q
    );

    reg q = 0;

    always @(negedge c)
        begin
        q <= d;
    end


endmodule

module FF(
    input d,
    input c,
    output q
    );

    reg q = 0;

    always @(posedge c)
        begin
        q <= d;
    end


endmodule

module FF1(
    input d,
    input c,
    output q
    );

    reg q = 1;

    always @(posedge c)
        begin
        q <= d;
    end


endmodule




module fifoTx(  
    
    input clock_in,
    input txe_n,  
    output [7:0]data_out,
    output wr_n, 
    
    input [7:0]data_in,
    output clock_out,
    input data_to_send,

    output transfer_on

    );  

reg [2:0]state = txe_is_high;
reg [2:0]next_state = txe_is_high;
reg transfer_on = 1'b0;
reg wr_n = 1'b1;
localparam txe_is_high = 3'b001;
localparam txe_is_low = 3'b010;
localparam wr_low = 3'b011;
localparam tx_end = 3'b100;

assign clock_out = (!wr_n) ? clock_in : 1'b0;
assign data_out = data_in;

always @ (*)
begin
    case(state)
        txe_is_high: begin
            transfer_on = 1'b0;

            if(txe_n == 1'b0) begin
                next_state = txe_is_low;
            end

        end
        txe_is_low: begin
            if(txe_n == 1'b1) begin
                next_state = txe_is_high;
            end else if (data_to_send == 1'b1) begin
                
                next_state = wr_low;
            end 
        end
        wr_low: begin

            if(txe_n == 1'b1) begin
                wr_n = 1'b1;
                transfer_on = 1'b0;
                next_state = txe_is_high;
            end else if (data_to_send == 1'b0) begin
                wr_n = 1'b1;
                transfer_on = 1'b0;
                next_state = txe_is_low;
            end else begin
                transfer_on <= 1'b1;
                wr_n = 1'b0;
            end

        end



    endcase

end

always @ (negedge clock_in)
begin
    state <= next_state;
end



endmodule