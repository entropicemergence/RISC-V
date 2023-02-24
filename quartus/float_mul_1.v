	module shifter_general (x, y, shift_amt);
		parameter width=4;
		
//		input [width:0]x;
//		input select;
//		output [width-1:0]y;
//		
//		wire [width-1:0]x1;
//		wire [width-1:0]x2;
//	
//		assign x1[width-1:0]={width{select}} & x[width:1];
//		assign x2[width-1:0]={width{~select}} & x[width-1:0];
//		
//		assign y[width-1:0] = x1[width-1:0] | x2[width-1:0];
		
	endmodule




	module bfloat_16_adder ();
	
	
	endmodule


	
	
	
	module shifter_1bit (x, y, select);
		parameter width=4;
		
		input [width:0]x;
		input select;
		output [width-1:0]y;
		
		wire [width-1:0]x1;
		wire [width-1:0]x2;
	
		assign x1[width-1:0]={width{select}} & x[width:1];
		assign x2[width-1:0]={width{~select}} & x[width-1:0];
		
		assign y[width-1:0] = x1[width-1:0] | x2[width-1:0];
		
	endmodule


//	module bfloat_16_mul (a, b, out);
	module bfloat_16_mul (a_sig, a_exp, a_s, b_sig, b_exp, b_s, out_sig, out_exp, out_s, out_temp);
		
		localparam sign=1;
		localparam exponent=8;
		localparam significand=7+1;
		localparam bit_size=16;
		
		
//		input [bit_size-1:0]a;
//		input [bit_size-1:0]b;
//		output [bit_size-1:0]out;
		
		input [7:0]a_sig;
		input [7:0]a_exp;
		input a_s;
		input [7:0]b_sig;
		input [7:0]b_exp;
		input b_s;
		output [7:0]out_sig;
		output [7:0]out_exp;
		output out_s;
		
		output [15:0]out_temp;

//		wire [7:0]x;
//		wire [7:0]y;
		wire [15:0]xy;
		
//		assign x[7]=1;
//		assign y[7]=1;
//		assign x[6:0]=a[6:0];
//		assign y[6:0]=b[6:0];
//		mul_8bit mul8_xy (.a(x[7:0]), .b(y[7:0]), .out(xy[15:0]));

		mul_8bit mul8_xy (.a(a_sig[7:0]), .b(b_sig[7:0]), .out(xy[15:0]));
		assign out_temp[15:0]=xy[15:0];
		
		
		
		shifter_1bit #(.width(8)) shifter_1bit (x[15:7], out_sig[7:0], xy[15]);
		
		wire [8:0]exp1;
		adder_b #(.n_bit(7)) fast_adder (.a(a_exp[7:0]), .b(b_exp[7:0]), .car(xy[15]), .out(exp1[7:0]) , .car_out(exp1[8]));
		

		assign out_exp[[6:0];
		
		
//		adder_b #(.n_bit(7)) fast_adder (.a(a[14:7]), .b(b[14:7]), .car(cary_1), .out(out[24:10]) , .car_out(cary_2));
//		adder_b #(.n_bit(7)) fast_adder (.a(a[14:7]), .b(b[14:7]), .car(cary_1), .out(out[24:10]) , .car_out(cary_2));
		
		
//		assign out[15]=a[15]^b[15];
		assign out_s=a_s^b_s;
		
	endmodule






	module mul_16bit (ax, by, out);
		localparam manti=16;
		localparam n_bit = manti*2;
		
		input [manti-1:0]ax;
		input [manti-1:0]by;
		output [n_bit-1:0]out;
		
		wire [31:0]x_y_a_b;
		wire [15:0]a_y;
		
		wire [15:0]x_b;
//		wire [15:0]a_b;
		
		mul_8bit mul8_xy (.a(ax[7:0]), .b(by[7:0]), .out(x_y_a_b[15:0]));
		mul_8bit mul8_ay (.a(ax[15:8]), .b(by[7:0]), .out(a_y[15:0]));

		mul_8bit mul8_xb (.a(ax[7:0]), .b(by[15:8]), .out(x_b[15:0]));
		mul_8bit mul8_ab (.a(ax[15:8]), .b(by[15:8]), .out(x_y_a_b[31:16]));
		
		
		
		wire [15:0]bus1_out;
		wire [15:0]bus1_cary;
		
		full_adder #(.unit(16)) full_adder (.x(x_y_a_b[23:8]) , .y(a_y[15:0]), .z(x_b[15:0]), .out(bus1_out[15:0]), .cary_out(bus1_cary[15:0]));
		
		wire [15:0]bus2;
		
		assign bus2[14:0]=bus1_out[15:1];
		assign bus2[15]=x_y_a_b[24];
		
		wire cary_1;
		half_adder_single half_adder (.xx(bus1_cary[0]) , .yy(bus2[0]), .ha_out(out[9]), .ha_cary(cary_1));
		
		wire cary_2;
		adder_b #(.n_bit(14)) fast_adder (.a(bus1_cary[15:1]), .b(bus2[15:1]), .car(cary_1), .out(out[24:10]) , .car_out(cary_2));
		
		wire overflow;
		carry_adder #(.unit(7)) carry_adder (.x(x_y_a_b[31:25]), .cary(cary_2), .out(out[31:25]), .overflow(overflow));
		
		assign out[7:0]=x_y_a_b[7:0];
		assign out[8]=bus1_out[0];
		
		
	endmodule



	module carry_adder #(	parameter unit=8)
		(x, cary, out, overflow);
		input [unit-1:0]x;
		input cary;
		output [unit-1:0]out;
		output overflow;
		
		
		assign out[0]=x[0]^cary;
		assign out[1]=(x[0]&cary)^x[1];
		
		genvar i;
		generate
		for(i = 0;i < (unit-2); i = i + 1) begin : ASSIGN_GEN
			assign out[i+2] = (( &x[i+1:0]) & cary) ^ x[i+2];
		end
		
		assign overflow = (&x[unit-1:0]) & cary;
		
		endgenerate
		
		
		
	endmodule




	module tree_builder #( 	parameter tree_width=15,
							parameter manti=8)
		(x , y, bus1, bus2, bus3, bus4, bus5, bus6, bus7, bus8);
		input [manti-1:0]x;
		input [manti-1:0]y;
		output [tree_width-1:0]bus1;
		output [tree_width-3:0]bus2;
		output [tree_width-5:0]bus3;
		output [tree_width-7:0]bus4;
		output [tree_width-9:0]bus5;
		output [tree_width-11:0]bus6;
		output [tree_width-13:0]bus7;
		output [tree_width-15:0]bus8;
		
		assign bus1[7:0]= x[7:0] & {8{y[0]}} ;
		assign bus1[14:8]= {7{x[7]}} & y[7:1] ;
		assign bus2[6:0]= x[6:0] & {7{y[1]}} ;
		assign bus2[12:7]= {6{x[6]}} & y[7:2] ;
		assign bus3[5:0]= x[5:0] & {6{y[2]}} ;
		assign bus3[10:6]= {5{x[5]}} & y[7:3] ;
		assign bus4[4:0]= x[4:0] & {5{y[3]}} ;
		assign bus4[8:5]= {4{x[4]}} & y[7:4] ;
		assign bus5[3:0]= x[3:0] & {4{y[4]}} ;
		assign bus5[6:4]= {3{x[3]}} & y[7:5] ;
		assign bus6[2:0]= x[2:0] & {3{y[5]}} ;
		assign bus6[4:3]= {2{x[2]}} & y[7:6] ;
		assign bus7[1:0]= x[1:0] & {2{y[6]}} ;
		assign bus7[2:2]= {1{x[1]}} & y[7:7] ;
		assign bus8[0:0]= x[0:0] & {1{y[7]}} ;

	endmodule

	


	module mul_8bit (a, b, out); 
		localparam manti=8;
		localparam n_bit = manti*2;
		localparam tree_width = n_bit-1;
		

//		reg h2;
//		reg [7:0]h3;
//		initial
//		begin
//		h3[0] =1;
//		h2=0;
//		end
		
		input [manti-1:0]a;
		input [manti-1:0]b;
		
		output [n_bit-1:0]out;
		
		wire [manti-1:0]x;
		wire [manti-1:0]y;
		
		wire [tree_width-1:0]bus1;
		wire [tree_width-3:0]bus2;
		wire [tree_width-5:0]bus3;
		wire [tree_width-7:0]bus4;
		wire [tree_width-9:0]bus5;
		wire [tree_width-11:0]bus6;
		wire [tree_width-13:0]bus7;
		wire [tree_width-15:0]bus8;
		

//		assign x[7]=0;
//		assign y[7]=0;
		assign x[7:0]=a[7:0];
		assign y[7:0]=b[7:0];
		
		
		tree_builder  #(.manti(manti), .tree_width(tree_width)) tree_builder 
		(.x(x) , .y(y), .bus1(bus1), .bus2(bus2), .bus3(bus3), .bus4(bus4), .bus5(bus5), .bus6(bus6), .bus7(bus7), .bus8(bus8));
		
		
		
		wire [14:0]bus_b_1;
		wire [12:0]bus_b_2;
		wire [10:0]bus_b_3;
		wire [8:0]bus_b_4;
		wire [6:0]bus_b_5;
		wire [5:0]bus_b_6;
		
		
		
		assign bus_b_6[3:1]=bus7[2:0];
		assign bus_b_6[5:4]=bus5[6:5];
		assign bus_b_5[5:2]=bus6[4:1];
		
		assign bus_b_1[5:4]=bus1[5:4];
		assign bus_b_1[11:10]=bus1[11:10];
		assign bus_b_2[4:3]=bus2[4:3];
		assign bus_b_3[4:3]=bus3[4:3];
		assign bus_b_3[9:8]=bus3[9:8];
		assign bus_b_4[3:2]=bus4[3:2];
		
		assign bus_b_5[1]=bus5[1];
		assign bus_b_2[5]=bus5[2];	
		assign bus_b_4[4]=bus8[0];	
		assign bus_b_3[7]=bus4[6];
		assign bus_b_5[6]=bus4[7];
		assign bus_b_4[7]=bus2[9];
		assign bus_b_2[10]=bus2[10];


		half_adder_single half_adder_b1 (.xx(bus1[6]) , .yy(bus2[5]), .ha_out(bus_b_1[6]), .ha_cary(bus_b_2[6]));
		full_adder #(.unit(3)) full_adder_b (.x(bus1[9:7]) , .y(bus2[8:6]), .z(bus3[7:5]), .out(bus_b_1[9:7]), .cary_out(bus_b_2[9:7]));
		
		half_adder_single half_adder_b2 (.xx(bus4[4]) , .yy(bus5[3]), .ha_out(bus_b_3[5]), .ha_cary(bus_b_4[5]));
		half_adder_single half_adder_b3 (.xx(bus4[5]) , .yy(bus5[4]), .ha_out(bus_b_3[6]), .ha_cary(bus_b_4[6]));
		
		
		wire [14:0]bus_c_1;
		wire [12:0]bus_c_2;
		wire [10:0]bus_c_3;
		wire [9:0]bus_c_4;
		
		assign bus_c_1[3]=bus1[3];
		assign bus_c_1[12]=bus1[12];
		assign bus_c_2[2]=bus2[2];
		assign bus_c_2[3]=bus3[2];
		assign bus_c_3[2]=bus4[1];
		assign bus_c_3[9]=bus4[8];
		assign bus_c_3[10]=bus2[11];
		assign bus_c_4[9]=bus3[10];
		
		half_adder_single half_adder_c1 (.xx(bus_b_1[4]) , .yy(bus_b_2[3]), .ha_out(bus_c_1[4]), .ha_cary(bus_c_2[4]));
		half_adder_single half_adder_c2 (.xx(bus_b_4[2]) , .yy(bus_b_5[1]), .ha_out(bus_c_3[3]), .ha_cary(bus_c_4[3]));
		full_adder #(.unit(7)) full_adder_c1 (.x(bus_b_1[11:5]) , .y(bus_b_2[10:4]), .z(bus_b_3[9:3]), .out(bus_c_1[11:5]), .cary_out(bus_c_2[11:5]));
		full_adder #(.unit(5)) full_adder_c2 (.x(bus_b_4[7:3]) , .y(bus_b_5[6:2]), .z(bus_b_6[5:1]), .out(bus_c_3[8:4]), .cary_out(bus_c_4[8:4]));
		
		
		
		wire [14:0]bus_d_1;
		wire [12:0]bus_d_2;
		wire [11:0]bus_d_3;
		
		assign bus_d_1[2]=bus1[2];
		assign bus_d_1[13]=bus1[13];
		assign bus_d_2[1]=bus2[1];
		assign bus_d_2[2]=bus3[1];
		assign bus_d_3[1]=bus4[0];
		assign bus_d_3[2]=bus5[0];
		assign bus_d_3[3]=bus6[0];
		assign bus_d_3[11]=bus2[12];
		assign bus_d_3[10:4]=bus_c_4[9:3];
		
		half_adder_single half_adder_d1 (.xx(bus_c_1[3]) , .yy(bus_c_2[2]), .ha_out(bus_d_1[3]), .ha_cary(bus_d_2[3]));
		full_adder #(.unit(9)) full_adder_d (.x(bus_c_1[12:4]) , .y(bus_c_2[11:3]), .z(bus_c_3[10:2]), .out(bus_d_1[12:4]), .cary_out(bus_d_2[12:4]));
		

		
		wire [14:0]bus_e_1;
		wire [13:0]bus_e_2;
		assign bus_e_1[14]=bus1[14];
		assign bus_e_1[1]=bus1[1];
		assign bus_e_2[0]=bus2[0];
		assign bus_e_2[1]=bus3[0];
		
//		half_adder_single (xx , yy, ha_out, ha_cary);	
		half_adder_single half_adder_e1 (.xx(bus_d_1[2]) , .yy(bus_d_2[1]), .ha_out(bus_e_1[2]), .ha_cary(bus_e_2[2]));
//		(x , y, z, out, cary_out);
		full_adder #(.unit(11)) full_adder_e (.x(bus_d_1[13:3]) , .y(bus_d_2[12:2]), .z(bus_d_3[11:1]), .out(bus_e_1[13:3]), .cary_out(bus_e_2[13:3]));
		
//		input [n_bit:0]a;	input [n_bit:0]b; 	input car; 	output [n_bit:0]out; 	output car_out;
		assign out[0]=bus1[0];
		adder_b #(.n_bit(13)) fast_adder_final (.a(bus_e_1[14:1]), .b(bus_e_2[13:0]), .car(h2), .out(out[14:1]) , .car_out(out[15]));

    endmodule 
	
	
	module full_adder #(	parameter unit=8
							)
//		(bus_a,bus_b,cary_1,cary_2);
		(x , y, z, out, cary_out);
		input [unit-1:0]x;
		input [unit-1:0]y;
		input [unit-1:0]z;
		output [unit-1:0]out;
		output [unit-1:0]cary_out;
		
		genvar i;
		generate
		for(i = 0;i < (unit); i = i + 1) begin : ASSIGN_GEN
			full_adder_single fa_single (.xx(x[i]) , .yy(y[i]), .zz(z[i]), .fa_out(out[i]), .fa_cary(cary_out[i]));
		end
		endgenerate

	endmodule
	
	module full_adder_single (xx , yy, zz, fa_out, fa_cary);

		input xx;
		input yy;
		input zz;
		output fa_out;
		output fa_cary;
		
		wire w1;
		wire w2;
		
		assign w1 = xx & yy;
		assign w2 = xx | yy;
		
		assign fa_out = (!w1 & w2) ^ zz;
		assign fa_cary= w1 | (w2 & zz);

	endmodule
	
	module half_adder_single (xx , yy, ha_out, ha_cary);
		input xx;
		input yy;
		output ha_out;
		output ha_cary;
		
		wire w1;
		wire w2;
		
		assign w1 = xx & yy;
		assign w2 = xx | yy;
		
		assign ha_out = (!w1 & w2);
		assign ha_cary = w1;
		
	endmodule
	
	

	
	
	

	