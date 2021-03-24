module FT245FifoWrite_tb;  
// Inputs  
reg clock;  
reg txe_n;
reg enable_data;
wire [7:0]dout;  
// Instantiate the Unit Under Test (UUT)  
communication uut (  

    .clock_in(clock),
    .txe_n(txe_n),
    .data_out(dout),
    .wr_n(wr_n),
    .enable(enable_data)

);  

integer i;

initial begin  

clock = 0; 
txe_n = 1; 
enable_data = 0;
#100;  
// Add stimulus here  
clock = 1;
for(i = 0; i < 10; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end

txe_n = 0; 



for(i = 0; i < 20; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end
#10 clock = 0; 
txe_n = 0; 
#10 clock = 1; 
for(i = 0; i < 10; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end
#10 clock = 0;
enable_data = 1;
#10 clock = 1;
for(i = 0; i < 20; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end
#10 clock = 0; 
enable_data = 0;
#10 clock = 1; 
for(i = 0; i < 20; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end
#10 clock = 1;  
enable_data = 1;
#10 clock = 0;  

for(i = 0; i < 20; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end
#10 clock = 0; 
enable_data = 0;
#10 clock = 1; 
for(i = 0; i < 20; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end
txe_n = 1; 
#10 clock = 1; 
for(i = 0; i < 20; i=i+1) begin
    #10 clock = 0;  
    #10 clock = 1;  
end


end  
initial begin  
$dumpfile("communication.vcd");  
$dumpvars;  
end  
endmodule