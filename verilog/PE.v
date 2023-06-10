// PE submodule
module PE(valid, Q, R, I_in, D_in, H_in0, H_in1, H_in2, I_out, D_out, H_out);
    
	input  valid;
    input  [1:0] Q;
	input  [1:0] R;
	input  signed [7:0] I_in,D_in;
	input  signed [7:0] H_in0,H_in1,H_in2;
	output signed [7:0] I_out,D_out;
	output [6:0] H_out;
	
	wire signed [7:0] H_t1,H_t2;
	wire signed [2:0] S;
	
	reg signed [7:0] I_out_r,D_out_r;
	reg [6:0] H_out_r;
	
	assign  S     = (R == Q) ? 2 : -1;

	assign H_t1 = (H_in0 + S >= 0)?(H_in0 + S):0;
	assign H_t2 = (I_out >= D_out)?I_out:D_out;
	
	assign H_out = H_out_r;
	assign I_out = I_out_r;
	assign D_out = D_out_r;

	always @(*) begin
		if (valid) begin
			H_out_r = (H_t1 >= H_t2)? H_t1:H_t2;
			I_out_r = (H_in1 - 2 >= I_in - 1)? (H_in1 - 2):(I_in - 1);
			D_out_r = (H_in2 - 2 >= D_in - 1)? (H_in2 - 2):(D_in - 1);
		end
		else begin
			H_out_r = 0;
			I_out_r = -128;
			D_out_r = -128;
		end
	end

endmodule