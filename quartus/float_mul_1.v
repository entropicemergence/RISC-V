
	
	module bfp16_mul #( parameter n_bit=16 ,
						parameter manti=8,
						parameter expo=8,
						parameter tree_width=15)
		(a, b, out, outb); 
		
		reg h;
		reg h2;
		reg [7:0]h3;
		
		input [n_bit-1:0]a;
		input [n_bit-1:0]b;
		output [n_bit-1:0]out;
		output [n_bit-1:0]outb;
		
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
		
		
		
		
		initial
		begin
		h3[0] =1;
		h=1;
		h2=0;
		end

		assign x[7]=1;
		assign y[7]=1;
		assign x[6:0]=a[6:0];
		assign y[6:0]=b[6:0];
		
		
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
		
//		assign out[7:0]=bus1[7:0];
//		assign out[14:8]=bus1[14:8];
		
		
		wire [14:0]bus_b_1;
		wire [12:0]bus_b_2;
		wire [10:0]bus_b_3;
		wire [8:0]bus_b_4;
		wire [6:0]bus_b_5;
		wire [5:0]bus_b_6;
		
		
		
		wire [14:0]bus_c_1;
		wire [12:0]bus_c_2;
		wire [10:0]bus_c_3;
		wire [9:0]bus_c_4;
		
		assign bus_c_1[3]=bus1[3];
		assign bus_c_2[2]=bus2[2];
		assign bus_c_2[3]=bus3[2];
		assign bus_c_3[2]=bus4[1];
		
		
		
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
		assign outb[0]=bus1[0];
		adder_b #(.n_bit(13)) fast_adder_final (.a(bus_e_1[14:1]), .b(bus_e_2[13:0]), .car(h2), .out(outb[14:1]) , .car_out(outb[15]));








//		assign outb[0:0]=bus8[0:0];
//		assign bus1[n_bit:0]=a[n_bit:0] & b[n_bit:0];
		
		

//		wire [n_bit:0]carw;
//		
//		assign bus1[n_bit:0]=a[n_bit:0] & b[n_bit:0];
//		assign bus2[n_bit:0]=a[n_bit:0] | b[n_bit:0];
//		
//		
//		assign carw[0]=car;
//		
//		wire a1;
//		and (a1,car,bus2[0]);
//		assign carw[1]=a1|bus1[0];
//		
//		wire [1:0]a2;
//		and (a2[0],car,bus2[0],bus2[1]);
//		and (a2[1],bus1[0],bus2[1]);
//		or (carw[2], |a2[1:0], bus1[1]);
//		
////		add_submodule_a #(.n(6),.k(0)) add_submodule_a_6 (.bus_a(bus1[5:0]), .bus_b(bus2[5:0]), .cary_1(carw[6]), .cary_2(car));
////		add_submodule_a #(.n(7),.k(0)) add_submodule_a_7 (.bus_a(bus1[6:0]), .bus_b(bus2[6:0]), .cary_1(carw[7]), .cary_2(car));
//		
//		genvar i;
//		generate
//		for(i = 3;i < n_bit+1; i = i + 1) begin : ASSIGN_GEN
//			add_submodule_a #(.n(i),.k(0)) add_submodule_a (.bus_a(bus1[i-1:0]), .bus_b(bus2[i-1:0]), .cary_1(carw[i]), .cary_2(car));
//		end
//		endgenerate
//		
//		assign out[n_bit:0]=(~bus1[n_bit:0] & bus2[n_bit:0])^carw[n_bit:0];
		
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
		assign ha_cary= w1;

	endmodule
	
	
	
	
	
//	module bfp16_mul_submodule #(	parameter n=7,
//								parameter k=7)
//		(bus_a,bus_b,cary_1,cary_2);
//		input [n-1:0]bus_a;
//		input [n-1:0]bus_b;
//		input cary_2;
//		output cary_1;
//		
//		wire [n-1:0]a;
//		and (a[0], cary_2, &bus_b[n-1:0]);
//		and (a[n-1],bus_a[n-2],bus_b[n-1]);
//
//		genvar i;
//		generate
//		for(i = 1;i < (n-1); i = i + 1) begin : ASSIGN_GEN
//			assign a[i]= bus_a[i-1] & (&bus_b[n-1:i]);
//		end
//		endgenerate
//		
//		or (cary_1, |a[n-1:0], bus_a[n-1]);
//
//	endmodule

	