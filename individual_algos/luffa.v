/*
 * Copyright (c) 2018 Sprocket
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License with
 * additional permissions to the one published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version. For more information see LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

module luffa512 (
	input clk,
	input [511:0] data,
	output [511:0] hash
);

	reg [255:0] M0, M1, M2, M3, M4;
	reg [255:0] V00, V01, V02, V03, V04;
	reg [255:0] V10, V11, V12, V13, V14;
	reg [255:0] V20, V21, V22, V23, V24;
	reg [255:0] V30, V31, V32, V33, V34;
	reg [255:0] V40, V41, V42, V43, V44;
	reg [255:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10;
		
	wire [255:0] R00, R01, R02, R03, R04;
	wire [255:0] R10, R11, R12, R13, R14;
	wire [255:0] R20, R21, R22, R23, R24;
	wire [255:0] R30, R31, R32, R33, R34;
	wire [255:0] R40, R41, R42, R43, R44;

	luffa_round lr0 (clk, M0, V00, V10, V20, V30, V40, R00, R10, R20, R30, R40 );
	luffa_round lr1 (clk, M1, V01, V11, V21, V31, V41, R01, R11, R21, R31, R41 );
	luffa_round lr2 (clk, M2, V02, V12, V22, V32, V42, R02, R12, R22, R32, R42 );
	luffa_round lr3 (clk, M3, V03, V13, V23, V33, V43, R03, R13, R23, R33, R43 );
	luffa_round lr4 (clk, M4, V04, V14, V24, V34, V44, R04, R14, R24, R34, R44 );
	
	reg [255:0] H0, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10;
	reg [511:0] H;
	
	assign hash = H;

	always @ (posedge clk) begin
	
		M0 <= data[511:256];
		M1 <= d10;
		M2 <= { 32'h80000000, 224'd0 };
		M3 <= 256'd0;
		M4 <= 256'd0;
		
		d10 <= d9;
		d9 <= d8;
		d8 <= d7;
		d7 <= d6;
		d6 <= d5;
		d5 <= d4;
		d4 <= d3;
		d3 <= d2;
		d2 <= d1;
		d1 <= d0;
		d0 <= data[255:0];
	
		V00 = 256'h6d251e6944b051e04eaa6fb4dbf784656e29201190152df4ee058139def610bb;
		V10 = 256'hc3b44b95d9d2f25670eee9a0de099fa35d9b05578fc944b3cf1ccf0e746cd581;
		V20 = 256'hf7efc89d5dba578104016ce5ad659c050306194f666d183624aa230a8b264ae7;
		V30 = 256'h858075d536d79ccee571f7d7204b1f6735870c6a57e9e92314bcb8087cde72ce;
		V40 = 256'h6c68e9be5ec41e22c825b7c7affb4363f5df39990fc688f1b07224cc03e86cea;
		
		V01 <= R00;
		V11 <= R10;
		V21 <= R20;
		V31 <= R30;
		V41 <= R40;

		V02 <= R01;
		V12 <= R11;
		V22 <= R21;
		V32 <= R31;
		V42 <= R41;

		V03 <= R02;
		V13 <= R12;
		V23 <= R22;
		V33 <= R32;
		V43 <= R42;

		V04 <= R03;
		V14 <= R13;
		V24 <= R23;
		V34 <= R33;
		V44 <= R43;
		
		H0[255:224] <= R03[255:224] ^ R13[255:224] ^ R23[255:224] ^ R33[255:224] ^ R43[255:224];
		H0[223:192] <= R03[223:192] ^ R13[223:192] ^ R23[223:192] ^ R33[223:192] ^ R43[223:192];
		H0[191:160] <= R03[191:160] ^ R13[191:160] ^ R23[191:160] ^ R33[191:160] ^ R43[191:160];
		H0[159:128] <= R03[159:128] ^ R13[159:128] ^ R23[159:128] ^ R33[159:128] ^ R43[159:128];
		H0[127: 96] <= R03[127: 96] ^ R13[127: 96] ^ R23[127: 96] ^ R33[127: 96] ^ R43[127: 96];
		H0[ 95: 64] <= R03[ 95: 64] ^ R13[ 95: 64] ^ R23[ 95: 64] ^ R33[ 95: 64] ^ R43[ 95: 64];
		H0[ 63: 32] <= R03[ 63: 32] ^ R13[ 63: 32] ^ R23[ 63: 32] ^ R33[ 63: 32] ^ R43[ 63: 32];
		H0[ 31:  0] <= R03[ 31:  0] ^ R13[ 31:  0] ^ R23[ 31:  0] ^ R33[ 31:  0] ^ R43[ 31:  0];

		H1 <= H0;
		H2 <= H1;
		H3 <= H2;
		H4 <= H3;
		H5 <= H4;
		H6 <= H5;
		H7 <= H6;
		H8 <= H7;
		H9 <= H8;
		H10 <= H9;

		H[511:256] <= H10;
		H[255:224] <= R04[255:224] ^ R14[255:224] ^ R24[255:224] ^ R34[255:224] ^ R44[255:224];
		H[223:192] <= R04[223:192] ^ R14[223:192] ^ R24[223:192] ^ R34[223:192] ^ R44[223:192];
		H[191:160] <= R04[191:160] ^ R14[191:160] ^ R24[191:160] ^ R34[191:160] ^ R44[191:160];
		H[159:128] <= R04[159:128] ^ R14[159:128] ^ R24[159:128] ^ R34[159:128] ^ R44[159:128];
		H[127: 96] <= R04[127: 96] ^ R14[127: 96] ^ R24[127: 96] ^ R34[127: 96] ^ R44[127: 96];
		H[ 95: 64] <= R04[ 95: 64] ^ R14[ 95: 64] ^ R24[ 95: 64] ^ R34[ 95: 64] ^ R44[ 95: 64];
		H[ 63: 32] <= R04[ 63: 32] ^ R14[ 63: 32] ^ R24[ 63: 32] ^ R34[ 63: 32] ^ R44[ 63: 32];
		H[ 31:  0] <= R04[ 31:  0] ^ R14[ 31:  0] ^ R24[ 31:  0] ^ R34[ 31:  0] ^ R44[ 31:  0];

//		$display("R00: %x", R00);
//		$display("R10: %x", R10);
//		$display("R20: %x", R20);
//		$display("R30: %x", R30);
//		$display("R40: %x", R40);
//
//		$display("R01: %x", R01);
//		$display("R11: %x", R11);
//		$display("R21: %x", R21);
//		$display("R31: %x", R31);
//		$display("R41: %x", R41);
//
//		$display("R02: %x", R02);
//		$display("R12: %x", R12);
//		$display("R22: %x", R22);
//		$display("R32: %x", R32);
//		$display("R42: %x", R42);
//
//		$display("R03: %x", R03);
//		$display("R13: %x", R13);
//		$display("R23: %x", R23);
//		$display("R33: %x", R33);
//		$display("R43: %x", R43);
//
//		$display("R04: %x", R04);
//		$display("R14: %x", R14);
//		$display("R24: %x", R24);
//		$display("R34: %x", R34);
//		$display("R44: %x", R44);
	
	end


endmodule

module luffa_round (
	input clk,
	input [255:0] M,
	input [255:0] V0,
	input [255:0] V1,
	input [255:0] V2,
	input [255:0] V3,
	input [255:0] V4,
	output reg [255:0] O0,
	output reg [255:0] O1,
	output reg [255:0] O2,
	output reg [255:0] O3,
	output reg [255:0] O4
);

	wire [255:0] LM0, LM1, LM2, LM3, LM4;

	// Message Injection
	luffa_mi lm00 (clk, M, V0, V1, V2, V3, V4, LM0, LM1, LM2, LM3, LM4 );
	
	wire [255:0] o00, o01, o02, o03, o04, o05, o06, o07;
	wire [255:0] o10, o11, o12, o13, o14, o15, o16, o17;
	wire [255:0] o20, o21, o22, o23, o24, o25, o26, o27;
	wire [255:0] o30, o31, o32, o33, o34, o35, o36, o37;
	wire [255:0] o40, o41, o42, o43, o44, o45, o46, o47;

	reg [255:0] i00, i01, i02, i03, i04, i05, i06, i07;
	reg [255:0] i10, i11, i12, i13, i14, i15, i16, i17;
	reg [255:0] i20, i21, i22, i23, i24, i25, i26, i27;
	reg [255:0] i30, i31, i32, i33, i34, i35, i36, i37;
	reg [255:0] i40, i41, i42, i43, i44, i45, i46, i47;
	
	// Permutation of V0
	luffa_permutation p00 (i00, 32'h303994a6, 32'he0337818, o00);
	luffa_permutation p01 (i01, 32'hc0e65299, 32'h441ba90d, o01);
	luffa_permutation p02 (i02, 32'h6cc33a12, 32'h7f34d442, o02);
	luffa_permutation p03 (i03, 32'hdc56983e, 32'h9389217f, o03);
	luffa_permutation p04 (i04, 32'h1e00108f, 32'he5a8bce6, o04);
	luffa_permutation p05 (i05, 32'h7800423d, 32'h5274baf4, o05);
	luffa_permutation p06 (i06, 32'h8f5b7882, 32'h26889ba7, o06);
	luffa_permutation p07 (i07, 32'h96e1db12, 32'h9a226e9d, o07);
                           
	// Permutation of V1
	luffa_permutation p10 (i10, 32'hb6de10ed, 32'h01685f3d, o10);
	luffa_permutation p11 (i11, 32'h70f47aae, 32'h05a17cf4, o11);
	luffa_permutation p12 (i12, 32'h0707a3d4, 32'hbd09caca, o12);
	luffa_permutation p13 (i13, 32'h1c1e8f51, 32'hf4272b28, o13);
	luffa_permutation p14 (i14, 32'h707a3d45, 32'h144ae5cc, o14);
	luffa_permutation p15 (i15, 32'haeb28562, 32'hfaa7ae2b, o15);
	luffa_permutation p16 (i16, 32'hbaca1589, 32'h2e48f1c1, o16);
	luffa_permutation p17 (i17, 32'h40a46f3e, 32'hb923c704, o17);
                           
	// Permutation of V2
	luffa_permutation p20 (i20, 32'hfc20d9d2, 32'he25e72c1, o20);
	luffa_permutation p21 (i21, 32'h34552e25, 32'he623bb72, o21);
	luffa_permutation p22 (i22, 32'h7ad8818f, 32'h5c58a4a4, o22);
	luffa_permutation p23 (i23, 32'h8438764a, 32'h1e38e2e7, o23);
	luffa_permutation p24 (i24, 32'hbb6de032, 32'h78e38b9d, o24);
	luffa_permutation p25 (i25, 32'hedb780c8, 32'h27586719, o25);
	luffa_permutation p26 (i26, 32'hd9847356, 32'h36eda57f, o26);
	luffa_permutation p27 (i27, 32'ha2c78434, 32'h703aace7, o27);
                           
	// Permutation of V3
	luffa_permutation p30 (i30, 32'hb213afa5, 32'he028c9bf, o30);
	luffa_permutation p31 (i31, 32'hc84ebe95, 32'h44756f91, o31);
	luffa_permutation p32 (i32, 32'h4e608a22, 32'h7e8fce32, o32);
	luffa_permutation p33 (i33, 32'h56d858fe, 32'h956548be, o33);
	luffa_permutation p34 (i34, 32'h343b138f, 32'hfe191be2, o34);
	luffa_permutation p35 (i35, 32'hd0ec4e3d, 32'h3cb226e5, o35);
	luffa_permutation p36 (i36, 32'h2ceb4882, 32'h5944a28e, o36);
	luffa_permutation p37 (i37, 32'hb3ad2208, 32'ha1c4c355, o37);
                           
	// oermutation of V4
	luffa_permutation p40 (i40, 32'hf0d2e9e3, 32'h5090d577, o40);
	luffa_permutation p41 (i41, 32'hac11d7fa, 32'h2d1925ab, o41);
	luffa_permutation p42 (i42, 32'h1bcb66f2, 32'hb46496ac, o42);
	luffa_permutation p43 (i43, 32'h6f2d9bc9, 32'hd1925ab0, o43);
	luffa_permutation p44 (i44, 32'h78602649, 32'h29131ab6, o44);
	luffa_permutation p45 (i45, 32'h8edae952, 32'h0fc053c3, o45);
	luffa_permutation p46 (i46, 32'h3b6ba548, 32'h3f014f0c, o46);
	luffa_permutation p47 (i47, 32'hedae9520, 32'hfc053c31, o47);

	always @ (posedge clk) begin

		i00 <= LM0;
		i01 <= o00;
		i02 <= o01;
		i03 <= o02;
		i04 <= o03;
		i05 <= o04;
		i06 <= o05;
		i07 <= o06;
		       
		i10 <= LM1;
		i11 <= o10;
		i12 <= o11;
		i13 <= o12;
		i14 <= o13;
		i15 <= o14;
		i16 <= o15;
		i17 <= o16;
               
		i20 <= LM2;
		i21 <= o20;
		i22 <= o21;
		i23 <= o22;
		i24 <= o23;
		i25 <= o24;
		i26 <= o25;
		i27 <= o26;
               
		i30 <= LM3;
		i31 <= o30;
		i32 <= o31;
		i33 <= o32;
		i34 <= o33;
		i35 <= o34;
		i36 <= o35;
		i37 <= o36;
               
		i40 <= LM4;
		i41 <= o40;
		i42 <= o41;
		i43 <= o42;
		i44 <= o43;
		i45 <= o44;
		i46 <= o45;
		i47 <= o46;

		O0 <= o07;
		O1 <= o17;
		O2 <= o27;
		O3 <= o37;
		O4 <= o47;
		
//		$display("LM0: %x", LM0);
//		$display("LM1: %x", LM1);
//		$display("LM2: %x", LM2);
//		$display("LM3: %x", LM3);
//		$display("LM4: %x", LM4);
//
//		$display("O0: %x", O0);
//		$display("O1: %x", O1);
//		$display("O2: %x", O2);
//		$display("O3: %x", O3);
//		$display("O4: %x", O4);


	end

endmodule

module luffa_mi (
	input clk,
	input [255:0] M,
	input [255:0] V0,
	input [255:0] V1,
	input [255:0] V2,
	input [255:0] V3,
	input [255:0] V4,
	output reg [255:0] O0,
	output reg [255:0] O1,
	output reg [255:0] O2,
	output reg [255:0] O3,
	output reg [255:0] O4
);

	reg [255:0] x0, x1;
	reg [255:0] m0, m1;
	reg [255:0] m00, m01, m02, m03, m04;
	reg [255:0] v00, v01, v02, v03, v04;
	reg [255:0] v10, v11, v12, v13, v14;
	reg [255:0] v20, v21, v22, v23, v24;
	reg [255:0] v30, v31, v32, v33, v34;
	reg [255:0] v40, v41, v42, v43, v44;
	
	always @ (posedge clk) begin

		x0[255:224] = V0[255:224] ^ V1[255:224] ^ V2[255:224] ^ V3[255:224] ^ V4[255:224];
		x0[223:192] = V0[223:192] ^ V1[223:192] ^ V2[223:192] ^ V3[223:192] ^ V4[223:192];
		x0[191:160] = V0[191:160] ^ V1[191:160] ^ V2[191:160] ^ V3[191:160] ^ V4[191:160];
		x0[159:128] = V0[159:128] ^ V1[159:128] ^ V2[159:128] ^ V3[159:128] ^ V4[159:128];
		x0[127: 96] = V0[127: 96] ^ V1[127: 96] ^ V2[127: 96] ^ V3[127: 96] ^ V4[127: 96];
		x0[ 95: 64] = V0[ 95: 64] ^ V1[ 95: 64] ^ V2[ 95: 64] ^ V3[ 95: 64] ^ V4[ 95: 64];
		x0[ 63: 32] = V0[ 63: 32] ^ V1[ 63: 32] ^ V2[ 63: 32] ^ V3[ 63: 32] ^ V4[ 63: 32];
		x0[ 31:  0] = V0[ 31:  0] ^ V1[ 31:  0] ^ V2[ 31:  0] ^ V3[ 31:  0] ^ V4[ 31:  0];
		
		m0[255:224] = x0[ 31:  0];
		m0[223:192] = x0[255:224] ^ x0[ 31:  0];
		m0[191:160] = x0[223:192];
		m0[159:128] = x0[191:160] ^ x0[ 31:  0];
		m0[127: 96] = x0[159:128] ^ x0[ 31:  0];
		m0[ 95: 64] = x0[127: 96];
		m0[ 63: 32] = x0[ 95: 64];
		m0[ 31:  0] = x0[ 63: 32];
		
		v00 = m0 ^ V0;
		v10 = m0 ^ V1;
		v20 = m0 ^ V2;
		v30 = m0 ^ V3;
		v40 = m0 ^ V4;
		
		m1[255:224] = v00[ 31:  0]                ^ v10[255:224];
		m1[223:192] = v00[255:224] ^ v00[ 31:  0] ^ v10[223:192];
		m1[191:160] = v00[223:192]                ^ v10[191:160];
		m1[159:128] = v00[191:160] ^ v00[ 31:  0] ^ v10[159:128];
		m1[127: 96] = v00[159:128] ^ v00[ 31:  0] ^ v10[127: 96];
		m1[ 95: 64] = v00[127: 96]                ^ v10[ 95: 64];
		m1[ 63: 32] = v00[ 95: 64]                ^ v10[ 63: 32];
		m1[ 31:  0] = v00[ 63: 32]                ^ v10[ 31:  0];

		v11[255:224] = v10[ 31:  0]                ^ v20[255:224];
		v11[223:192] = v10[255:224] ^ v10[ 31:  0] ^ v20[223:192];
		v11[191:160] = v10[223:192]                ^ v20[191:160];
		v11[159:128] = v10[191:160] ^ v10[ 31:  0] ^ v20[159:128];
		v11[127: 96] = v10[159:128] ^ v10[ 31:  0] ^ v20[127: 96];
		v11[ 95: 64] = v10[127: 96]                ^ v20[ 95: 64];
		v11[ 63: 32] = v10[ 95: 64]                ^ v20[ 63: 32];
		v11[ 31:  0] = v10[ 63: 32]                ^ v20[ 31:  0];

		v21[255:224] = v20[ 31:  0]                ^ v30[255:224];
		v21[223:192] = v20[255:224] ^ v20[ 31:  0] ^ v30[223:192];
		v21[191:160] = v20[223:192]                ^ v30[191:160];
		v21[159:128] = v20[191:160] ^ v20[ 31:  0] ^ v30[159:128];
		v21[127: 96] = v20[159:128] ^ v20[ 31:  0] ^ v30[127: 96];
		v21[ 95: 64] = v20[127: 96]                ^ v30[ 95: 64];
		v21[ 63: 32] = v20[ 95: 64]                ^ v30[ 63: 32];
		v21[ 31:  0] = v20[ 63: 32]                ^ v30[ 31:  0];

		v31[255:224] = v30[ 31:  0]                ^ v40[255:224];
		v31[223:192] = v30[255:224] ^ v30[ 31:  0] ^ v40[223:192];
		v31[191:160] = v30[223:192]                ^ v40[191:160];
		v31[159:128] = v30[191:160] ^ v30[ 31:  0] ^ v40[159:128];
		v31[127: 96] = v30[159:128] ^ v30[ 31:  0] ^ v40[127: 96];
		v31[ 95: 64] = v30[127: 96]                ^ v40[ 95: 64];
		v31[ 63: 32] = v30[ 95: 64]                ^ v40[ 63: 32];
		v31[ 31:  0] = v30[ 63: 32]                ^ v40[ 31:  0];

		v41[255:224] = v40[ 31:  0]                ^ v00[255:224];
		v41[223:192] = v40[255:224] ^ v40[ 31:  0] ^ v00[223:192];
		v41[191:160] = v40[223:192]                ^ v00[191:160];
		v41[159:128] = v40[191:160] ^ v40[ 31:  0] ^ v00[159:128];
		v41[127: 96] = v40[159:128] ^ v40[ 31:  0] ^ v00[127: 96];
		v41[ 95: 64] = v40[127: 96]                ^ v00[ 95: 64];
		v41[ 63: 32] = v40[ 95: 64]                ^ v00[ 63: 32];
		v41[ 31:  0] = v40[ 63: 32]                ^ v00[ 31:  0];

		v01[255:224] = m1[ 31:  0]                ^ v41[255:224];
		v01[223:192] = m1[255:224] ^ m1[ 31:  0]  ^ v41[223:192];
		v01[191:160] = m1[223:192]                ^ v41[191:160];
		v01[159:128] = m1[191:160] ^ m1[ 31:  0]  ^ v41[159:128];
		v01[127: 96] = m1[159:128] ^ m1[ 31:  0]  ^ v41[127: 96];
		v01[ 95: 64] = m1[127: 96]                ^ v41[ 95: 64];
		v01[ 63: 32] = m1[ 95: 64]                ^ v41[ 63: 32];
		v01[ 31:  0] = m1[ 63: 32]                ^ v41[ 31:  0];
		
		v42[255:224] = v41[ 31:  0]                ^ v31[255:224];
		v42[223:192] = v41[255:224] ^ v41[ 31:  0] ^ v31[223:192];
		v42[191:160] = v41[223:192]                ^ v31[191:160];
		v42[159:128] = v41[191:160] ^ v41[ 31:  0] ^ v31[159:128];
		v42[127: 96] = v41[159:128] ^ v41[ 31:  0] ^ v31[127: 96];
		v42[ 95: 64] = v41[127: 96]                ^ v31[ 95: 64];
		v42[ 63: 32] = v41[ 95: 64]                ^ v31[ 63: 32];
		v42[ 31:  0] = v41[ 63: 32]                ^ v31[ 31:  0];
		
		v32[255:224] = v31[ 31:  0]                ^ v21[255:224];
		v32[223:192] = v31[255:224] ^ v31[ 31:  0] ^ v21[223:192];
		v32[191:160] = v31[223:192]                ^ v21[191:160];
		v32[159:128] = v31[191:160] ^ v31[ 31:  0] ^ v21[159:128];
		v32[127: 96] = v31[159:128] ^ v31[ 31:  0] ^ v21[127: 96];
		v32[ 95: 64] = v31[127: 96]                ^ v21[ 95: 64];
		v32[ 63: 32] = v31[ 95: 64]                ^ v21[ 63: 32];
		v32[ 31:  0] = v31[ 63: 32]                ^ v21[ 31:  0];
		
		v22[255:224] = v21[ 31:  0]                ^ v11[255:224];
		v22[223:192] = v21[255:224] ^ v21[ 31:  0] ^ v11[223:192];
		v22[191:160] = v21[223:192]                ^ v11[191:160];
		v22[159:128] = v21[191:160] ^ v21[ 31:  0] ^ v11[159:128];
		v22[127: 96] = v21[159:128] ^ v21[ 31:  0] ^ v11[127: 96];
		v22[ 95: 64] = v21[127: 96]                ^ v11[ 95: 64];
		v22[ 63: 32] = v21[ 95: 64]                ^ v11[ 63: 32];
		v22[ 31:  0] = v21[ 63: 32]                ^ v11[ 31:  0];
		
		v12[255:224] = v11[ 31:  0]                ^ m1[255:224];
		v12[223:192] = v11[255:224] ^ v11[ 31:  0] ^ m1[223:192];
		v12[191:160] = v11[223:192]                ^ m1[191:160];
		v12[159:128] = v11[191:160] ^ v11[ 31:  0] ^ m1[159:128];
		v12[127: 96] = v11[159:128] ^ v11[ 31:  0] ^ m1[127: 96];
		v12[ 95: 64] = v11[127: 96]                ^ m1[ 95: 64];
		v12[ 63: 32] = v11[ 95: 64]                ^ m1[ 63: 32];
		v12[ 31:  0] = v11[ 63: 32]                ^ m1[ 31:  0];
		
		v02 = v01;

		v03 = v02 ^ M;

		m01[255:224] = M[ 31:  0];
		m01[223:192] = M[255:224] ^ M[ 31:  0];
		m01[191:160] = M[223:192];
		m01[159:128] = M[191:160] ^ M[ 31:  0];
		m01[127: 96] = M[159:128] ^ M[ 31:  0];
		m01[ 95: 64] = M[127: 96];
		m01[ 63: 32] = M[ 95: 64];
		m01[ 31:  0] = M[ 63: 32];

		v13 = v12 ^ m01;

		m02[255:224] = m01[ 31:  0];
		m02[223:192] = m01[255:224] ^ m01[ 31:  0];
		m02[191:160] = m01[223:192];
		m02[159:128] = m01[191:160] ^ m01[ 31:  0];
		m02[127: 96] = m01[159:128] ^ m01[ 31:  0];
		m02[ 95: 64] = m01[127: 96];
		m02[ 63: 32] = m01[ 95: 64];
		m02[ 31:  0] = m01[ 63: 32];
		
		v23 = v22 ^ m02;

		m03[255:224] = m02[ 31:  0];
		m03[223:192] = m02[255:224] ^ m02[ 31:  0];
		m03[191:160] = m02[223:192];
		m03[159:128] = m02[191:160] ^ m02[ 31:  0];
		m03[127: 96] = m02[159:128] ^ m02[ 31:  0];
		m03[ 95: 64] = m02[127: 96];
		m03[ 63: 32] = m02[ 95: 64];
		m03[ 31:  0] = m02[ 63: 32];
	
		v33 = v32 ^ m03;

		m04[255:224] = m03[ 31:  0];
		m04[223:192] = m03[255:224] ^ m03[ 31:  0];
		m04[191:160] = m03[223:192];
		m04[159:128] = m03[191:160] ^ m03[ 31:  0];
		m04[127: 96] = m03[159:128] ^ m03[ 31:  0];
		m04[ 95: 64] = m03[127: 96];
		m04[ 63: 32] = m03[ 95: 64];
		m04[ 31:  0] = m03[ 63: 32];
	
		v43 = v42 ^ m04;
		
//		O0 = v03;
//		O1 = v13;
//		O2 = v23;
//		O3 = v33;
//		O4 = v43;

		// Tweak
		O0 = v03;

		O1 = {
				v13[255:128],
				{ v13[126: 96], v13[127] },
				{ v13[ 94: 64], v13[ 95] },
				{ v13[ 62: 32], v13[ 63] },
				{ v13[ 30:  0], v13[ 31] }
			  };

		O2 = {
				v23[255:128],
				{ v23[125: 96], v23[127:126] },
				{ v23[ 93: 64], v23[ 95: 94] },
				{ v23[ 61: 32], v23[ 63: 62] },
				{ v23[ 29:  0], v23[ 31: 30] }
			  };

		O3 = {
				v33[255:128],
				{ v33[124: 96], v33[127:125] },
				{ v33[ 92: 64], v33[ 95: 93] },
				{ v33[ 60: 32], v33[ 63: 61] },
				{ v33[ 28:  0], v33[ 31: 29] }
			  };

		O4 = {
				v43[255:128],
				{ v43[123: 96], v43[127:124] },
				{ v43[ 91: 64], v43[ 95: 92] },
				{ v43[ 59: 32], v43[ 63: 60] },
				{ v43[ 27:  0], v43[ 31: 28] }
			  };
		
//		$display("O0: %x", O0);
//		$display("O1: %x", O1);
//		$display("O2: %x", O2);
//		$display("O3: %x", O3);
//		$display("O4: %x", O4);
		
	end

endmodule

module luffa_permutation (
	input [255:0] m,
	input [31:0] const_0,
	input [31:0] const_4,
	output [255:0] h
);

	wire [31:0] mi_0, mi_1, mi_2, mi_3, mi_4, mi_5, mi_6, mi_7;
	wire [31:0] sub_0, sub_1, sub_2, sub_3, sub_4, sub_5, sub_6, sub_7;
	wire [31:0] mix_0, mix_1, mix_2, mix_3, mix_4, mix_5, mix_6, mix_7;
//	wire [31:0] h_0, h_1, h_2, h_3, h_4, h_5, h_6, h_7;

	assign { mi_0, mi_1, mi_2, mi_3, mi_4, mi_5, mi_6, mi_7 } = m;

	luffa_sub luffa_sub0(mi_0, mi_1, mi_2, mi_3, sub_0, sub_1, sub_2, sub_3);
	luffa_sub luffa_sub1(mi_5, mi_6, mi_7, mi_4, sub_5, sub_6, sub_7, sub_4);
	luffa_mix luffa_mix0(sub_0, sub_4, mix_0, mix_4);
	luffa_mix luffa_mix1(sub_1, sub_5, mix_1, mix_5);
	luffa_mix luffa_mix2(sub_2, sub_6, mix_2, mix_6);
	luffa_mix luffa_mix3(sub_3, sub_7, mix_3, mix_7);

//	assign h_0 = mix_0 ^ const_0;
//	assign h_1 = mix_1;
//	assign h_2 = mix_2;
//	assign h_3 = mix_3;
//	assign h_4 = mix_4 ^ const_4;
//	assign h_5 = mix_5;
//	assign h_6 = mix_6;
//	assign h_7 = mix_7;

	assign h = { mix_0 ^ const_0, mix_1, mix_2, mix_3, mix_4 ^ const_4, mix_5, mix_6, mix_7 };


endmodule

module luffa_sub (
	input  [31:0] in0,
	input  [31:0] in1,
	input  [31:0] in2,
	input  [31:0] in3,
	output [31:0] out0,
	output [31:0] out1,
	output [31:0] out2,
	output [31:0] out3
);

	wire [31:0] r4_0, r0_0, r2_0, r1_0, r0_1, r3_0, r1_1, r3_1, r2_1, r0_2, r2_2, r1_2;

	assign r4_0 = in0;
	assign r0_0 = in0 | in1;
	assign r2_0 = in2 ^ in3;
	assign r1_0 = ~in1;
	assign r0_1 = r0_0 ^ in3;
	assign r3_0 = in3 & r4_0;
	assign r1_1 = r1_0 ^ r3_0;
	assign r3_1 = r3_0 ^ r2_0;
	assign r2_1 = r2_0 & r0_1;
	assign r0_2 = ~r0_1;
	assign r2_2 = r2_1 ^ r1_1;
	assign r1_2 = r1_1 | r3_1;
	assign out0 = r4_0 ^ r1_2;
	assign out3 = r3_1 ^ r2_2;
	assign out2 = r2_2 & r1_2;
	assign out1 = r1_2 ^ r0_2;

endmodule

module luffa_mix (
	input  [31:0] in0,
	input  [31:0] in1,	
	output [31:0] out0,
	output [31:0] out1
);

	wire [31:0] xr_0, xl_0, xr_1;

	assign xr_0 = in0 ^ in1;
	assign xl_0 = { in0[29:0], in0[31:30] } ^ xr_0;
	assign xr_1 = xl_0 ^ { xr_0[17:0], xr_0[31:18] };
	assign out0 = { xl_0[21:0], xl_0[31:22] } ^ xr_1;
	assign out1 = { xr_1[30:0], xr_1[31] };

endmodule
