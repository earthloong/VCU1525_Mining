/*
 * Copyright (c) 2017 Sprocket
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

module cube512 (
	input clk,
	input [511:0] data,
	output [511:0] hash
);
	
	wire [511:0] data_le;
	reg [511:0] hash_le;

	genvar j;
	generate
		for( j=0; j < 64 ; j = j + 1) begin: DATA_REVERSE
			assign data_le[j*8 +: 8] = data[(63-j)*8 +: 8];
		end
	endgenerate

	generate
		for( j=0; j < 64 ; j = j + 1) begin: HASH_REVERSE
			assign hash[j*8 +: 8] = hash_le[(63-j)*8 +: 8];
		end
	endgenerate


	reg [1023:0] i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,iA,iB,iC;
	reg [255:0] d,d1,d2,d3,d4,d5,d6,d7,d8,d9,dA,dB,dC,dD,dE,dF,dG;

	wire [1023:0] o0,o1,o2,o3,o4,o5,o6,o7,o8,o9,oA,oB,oC;

	cube_round cr0 (clk, i0, o0);
	cube_round cr1 (clk, i1, o1);
	cube_round cr2 (clk, i2, o2);
	cube_round cr3 (clk, i3, o3);
	cube_round cr4 (clk, i4, o4);
	cube_round cr5 (clk, i5, o5);
	cube_round cr6 (clk, i6, o6);
	cube_round cr7 (clk, i7, o7);
	cube_round cr8 (clk, i8, o8);
	cube_round cr9 (clk, i9, o9);
	cube_round crA (clk, iA, oA);
	cube_round crB (clk, iB, oB);
	cube_round crC (clk, iC, oC);
	
	always @ (posedge clk) begin
	
		d  <= dG;
		dG <= dF;
		dF <= dE;
		dE <= dD;
		dD <= dC;
		dC <= dB;
		dB <= dA;
		dA <= d9;
		d9 <= d8;
		d8 <= d7;
		d7 <= d6;
		d6 <= d5;
		d5 <= d4;
		d4 <= d3;
		d3 <= d2;
		d2 <= d1;
		d1 <= data_le[511:256];

		i0[1023:992] <= data_le[  0 +: 32] ^ 32'h2AEA2A61;
		i0[991:960]  <= data_le[ 32 +: 32] ^ 32'h50F494D4;
		i0[959:928]  <= data_le[ 64 +: 32] ^ 32'h2D538B8B;
		i0[927:896]  <= data_le[ 96 +: 32] ^ 32'h4167D83E;
		i0[895:864]  <= data_le[128 +: 32] ^ 32'h3FEE2313;
		i0[863:832]  <= data_le[160 +: 32] ^ 32'hC701CF8C;
		i0[831:800]  <= data_le[192 +: 32] ^ 32'hCC39968E;
		i0[799:768]  <= data_le[224 +: 32] ^ 32'h50AC5695;
		i0[767:  0]  <= 768'h4D42C787A647A8B397CF0BEF825B4537EEF864D2F22090C4D0E5CD33A23911AEFCD398D9148FE4851B017BEFB64445326A5361592FF5781C91FA79340DBADEA9D65C8A2BA5A70E75B1C62456BC7965761921C8F7E7989AF17795D246D43E3B44;
				
		i1[1023:992] <= o0[1023:992] ^ d[  0 +: 32];
		i1[991:960]  <= o0[991:960]  ^ d[ 32 +: 32];
		i1[959:928]  <= o0[959:928]  ^ d[ 64 +: 32];
		i1[927:896]  <= o0[927:896]  ^ d[ 96 +: 32];
		i1[895:864]  <= o0[895:864]  ^ d[128 +: 32];
		i1[863:832]  <= o0[863:832]  ^ d[160 +: 32];
		i1[831:800]  <= o0[831:800]  ^ d[192 +: 32];
		i1[799:768]  <= o0[799:768]  ^ d[224 +: 32];
		i1[767:  0]  <= o0[767:  0];

		i2[1023:1000] <= o1[1023:1000];
		i2[999:992] <= o1[999:992] ^ 8'h80;
		i2[991:  0] <= o1[991:  0];
				
		i3 <= o2;
		i3[1023:8] <= o2[1023:8];
		i3[7:0] <= o2[7:0] ^ 8'h01;
				
		i4 <= o3;
		i5 <= o4;
		i6 <= o5;
		i7 <= o6;
		i8 <= o7;
		i9 <= o8;
		iA <= o9;
		iB <= oA;
		iC <= oB;

		hash_le <= {
			oC[543:512],
			oC[575:544],
			oC[607:576],
			oC[639:608],
			oC[671:640],
			oC[703:672],
			oC[735:704],
			oC[767:736],
			oC[799:768],
			oC[831:800],
			oC[863:832],
			oC[895:864],
			oC[927:896],
			oC[959:928],
			oC[991:960],
			oC[1023:992]
		};

	end

endmodule

module cube_round (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	wire [1023:0] r0, r1, r2, r3, r4, r5, r6;
	
	cube_round_mix rm0 (clk, in, r0);
	cube_round_mix rm1 (clk, r0, r1);
	cube_round_mix rm2 (clk, r1, r2);
	cube_round_mix rm3 (clk, r2, r3);
	cube_round_mix rm4 (clk, r3, r4);
	cube_round_mix rm5 (clk, r4, r5);
	cube_round_mix rm6 (clk, r5, r6);
	cube_round_mix rm7 (clk, r6, out);

endmodule

module cube_round_mix (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	wire [1023:0] rm;

	cube_round_mix_1 rm1 (clk, in, rm);
	cube_round_mix_2 rm2 (clk, rm, out);

endmodule

module cube_round_mix_1 (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	reg [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
	reg [31:0] x8, x9, xa, xb, xc, xd, xe, xf;
	reg [31:0] xg, xh, xi, xj, xk, xl, xm, xn;
	reg [31:0] xo, xp, xq, xr, xs, xt, xu, xv;
	
	assign out = { x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv };

	always @ (posedge clk) begin
	
		{ x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv } = in;

		xg = x0 + xg;
		x0 = { x0[24:0], x0[31:25] };
		xh = x1 + xh;
		x1 = { x1[24:0], x1[31:25] };
		xi = x2 + xi;
		x2 = { x2[24:0], x2[31:25] };
		xj = x3 + xj;
		x3 = { x3[24:0], x3[31:25] };
		xk = x4 + xk;
		x4 = { x4[24:0], x4[31:25] };
		xl = x5 + xl;
		x5 = { x5[24:0], x5[31:25] };
		xm = x6 + xm;
		x6 = { x6[24:0], x6[31:25] };
		xn = x7 + xn;
		x7 = { x7[24:0], x7[31:25] };
		xo = x8 + xo;
		x8 = { x8[24:0], x8[31:25] };
		xp = x9 + xp;
		x9 = { x9[24:0], x9[31:25] };
		xq = xa + xq;
		xa = { xa[24:0], xa[31:25] };
		xr = xb + xr;
		xb = { xb[24:0], xb[31:25] };
		xs = xc + xs;
		xc = { xc[24:0], xc[31:25] };
		xt = xd + xt;
		xd = { xd[24:0], xd[31:25] };
		xu = xe + xu;
		xe = { xe[24:0], xe[31:25] };
		xv = xf + xv;
		xf = { xf[24:0], xf[31:25] };
		x8 = x8 ^ xg;
		x9 = x9 ^ xh;
		xa = xa ^ xi;
		xb = xb ^ xj;
		xc = xc ^ xk;
		xd = xd ^ xl;
		xe = xe ^ xm;
		xf = xf ^ xn;
		x0 = x0 ^ xo;
		x1 = x1 ^ xp;
		x2 = x2 ^ xq;
		x3 = x3 ^ xr;
		x4 = x4 ^ xs;
		x5 = x5 ^ xt;
		x6 = x6 ^ xu;
		x7 = x7 ^ xv;
		xi = x8 + xi;
		x8 = { x8[20:0], x8[31:21] };
		xj = x9 + xj;
		x9 = { x9[20:0], x9[31:21] };
		xg = xa + xg;
		xa = { xa[20:0], xa[31:21] };
		xh = xb + xh;
		xb = { xb[20:0], xb[31:21] };
		xm = xc + xm;
		xc = { xc[20:0], xc[31:21] };
		xn = xd + xn;
		xd = { xd[20:0], xd[31:21] };
		xk = xe + xk;
		xe = { xe[20:0], xe[31:21] };
		xl = xf + xl;
		xf = { xf[20:0], xf[31:21] };
		xq = x0 + xq;
		x0 = { x0[20:0], x0[31:21] };
		xr = x1 + xr;
		x1 = { x1[20:0], x1[31:21] };
		xo = x2 + xo;
		x2 = { x2[20:0], x2[31:21] };
		xp = x3 + xp;
		x3 = { x3[20:0], x3[31:21] };
		xu = x4 + xu;
		x4 = { x4[20:0], x4[31:21] };
		xv = x5 + xv;
		x5 = { x5[20:0], x5[31:21] };
		xs = x6 + xs;
		x6 = { x6[20:0], x6[31:21] };
		xt = x7 + xt;
		x7 = { x7[20:0], x7[31:21] };
		xc = xc ^ xi;
		xd = xd ^ xj;
		xe = xe ^ xg;
		xf = xf ^ xh;
		x8 = x8 ^ xm;
		x9 = x9 ^ xn;
		xa = xa ^ xk;
		xb = xb ^ xl;
		x4 = x4 ^ xq;
		x5 = x5 ^ xr;
		x6 = x6 ^ xo;
		x7 = x7 ^ xp;
		x0 = x0 ^ xu;
		x1 = x1 ^ xv;
		x2 = x2 ^ xs;
		x3 = x3 ^ xt;

	end
	
endmodule

module cube_round_mix_2 (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	reg [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
	reg [31:0] x8, x9, xa, xb, xc, xd, xe, xf;
	reg [31:0] xg, xh, xi, xj, xk, xl, xm, xn;
	reg [31:0] xo, xp, xq, xr, xs, xt, xu, xv;
	
	assign out = { x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv };

	always @ (posedge clk) begin
	
		{ x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv } = in;

		xj = xc + xj;
		xc = { xc[24:0], xc[31:25] };
		xi = xd + xi;
		xd = { xd[24:0], xd[31:25] };
		xh = xe + xh;
		xe = { xe[24:0], xe[31:25] };
		xg = xf + xg;
		xf = { xf[24:0], xf[31:25] };
		xn = x8 + xn;
		x8 = { x8[24:0], x8[31:25] };
		xm = x9 + xm;
		x9 = { x9[24:0], x9[31:25] };
		xl = xa + xl;
		xa = { xa[24:0], xa[31:25] };
		xk = xb + xk;
		xb = { xb[24:0], xb[31:25] };
		xr = x4 + xr;
		x4 = { x4[24:0], x4[31:25] };
		xq = x5 + xq;
		x5 = { x5[24:0], x5[31:25] };
		xp = x6 + xp;
		x6 = { x6[24:0], x6[31:25] };
		xo = x7 + xo;
		x7 = { x7[24:0], x7[31:25] };
		xv = x0 + xv;
		x0 = { x0[24:0], x0[31:25] };
		xu = x1 + xu;
		x1 = { x1[24:0], x1[31:25] };
		xt = x2 + xt;
		x2 = { x2[24:0], x2[31:25] };
		xs = x3 + xs;
		x3 = { x3[24:0], x3[31:25] };
		x4 = x4 ^ xj;
		x5 = x5 ^ xi;
		x6 = x6 ^ xh;
		x7 = x7 ^ xg;
		x0 = x0 ^ xn;
		x1 = x1 ^ xm;
		x2 = x2 ^ xl;
		x3 = x3 ^ xk;
		xc = xc ^ xr;
		xd = xd ^ xq;
		xe = xe ^ xp;
		xf = xf ^ xo;
		x8 = x8 ^ xv;
		x9 = x9 ^ xu;
		xa = xa ^ xt;
		xb = xb ^ xs;
		xh = x4 + xh;
		x4 = { x4[20:0], x4[31:21] };
		xg = x5 + xg;
		x5 = { x5[20:0], x5[31:21] };
		xj = x6 + xj;
		x6 = { x6[20:0], x6[31:21] };
		xi = x7 + xi;
		x7 = { x7[20:0], x7[31:21] };
		xl = x0 + xl;
		x0 = { x0[20:0], x0[31:21] };
		xk = x1 + xk;
		x1 = { x1[20:0], x1[31:21] };
		xn = x2 + xn;
		x2 = { x2[20:0], x2[31:21] };
		xm = x3 + xm;
		x3 = { x3[20:0], x3[31:21] };
		xp = xc + xp;
		xc = { xc[20:0], xc[31:21] };
		xo = xd + xo;
		xd = { xd[20:0], xd[31:21] };
		xr = xe + xr;
		xe = { xe[20:0], xe[31:21] };
		xq = xf + xq;
		xf = { xf[20:0], xf[31:21] };
		xt = x8 + xt;
		x8 = { x8[20:0], x8[31:21] };
		xs = x9 + xs;
		x9 = { x9[20:0], x9[31:21] };
		xv = xa + xv;
		xa = { xa[20:0], xa[31:21] };
		xu = xb + xu;
		xb = { xb[20:0], xb[31:21] };
		x0 = x0 ^ xh;
		x1 = x1 ^ xg;
		x2 = x2 ^ xj;
		x3 = x3 ^ xi;
		x4 = x4 ^ xl;
		x5 = x5 ^ xk;
		x6 = x6 ^ xn;
		x7 = x7 ^ xm;
		x8 = x8 ^ xp;
		x9 = x9 ^ xo;
		xa = xa ^ xr;
		xb = xb ^ xq;
		xc = xc ^ xt;
		xd = xd ^ xs;
		xe = xe ^ xv;
		xf = xf ^ xu;

	end
	
endmodule








module cube512_test (
	input clk,
	input rst,
	input [511:0] data,
	output [511:0] hash
);
	
	wire [511:0] data_le;
	reg [511:0] hash_le;

	genvar j;
	generate
		for( j=0; j < 64 ; j = j + 1) begin: DATA_REVERSE
			assign data_le[j*8 +: 8] = data[(63-j)*8 +: 8];
		end
	endgenerate

	generate
		for( j=0; j < 64 ; j = j + 1) begin: HASH_REVERSE
			assign hash[j*8 +: 8] = hash_le[(63-j)*8 +: 8];
		end
	endgenerate


	reg [1023:0] i00,i01,i02,i03,i04,i05,i06,i07,i08,i09,i0A,i0B,i0C,i0D,i0E,i0F;
	reg [1023:0] i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i1A,i1B,i1C,i1D,i1E,i1F;
	reg [1023:0] i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i2A,i2B,i2C,i2D,i2E,i2F;
	reg [1023:0] i30,i31,i32,i33,i34,i35,i36,i37,i38,i39,i3A,i3B,i3C,i3D,i3E,i3F;
	reg [1023:0] i40,i41,i42,i43,i44,i45,i46,i47,i48,i49,i4A,i4B,i4C,i4D,i4E,i4F;
	reg [1023:0] i50,i51,i52,i53,i54,i55,i56,i57,i58,i59,i5A,i5B,i5C,i5D,i5E,i5F;
	reg [1023:0] i60,i61,i62,i63,i64,i65,i66,i67,i68,i69,i6A,i6B,i6C,i6D,i6E,i6F;
	reg [1023:0] i70,i71,i72,i73,i74,i75,i76,i77,i78,i79,i7A,i7B,i7C,i7D,i7E,i7F;
	reg [1023:0] i80,i81,i82,i83,i84,i85,i86,i87,i88,i89,i8A,i8B,i8C,i8D,i8E,i8F;
	reg [1023:0] i90,i91,i92,i93,i94,i95,i96,i97,i98,i99,i9A,i9B,i9C,i9D,i9E,i9F;
	reg [1023:0] iA0,iA1,iA2,iA3,iA4,iA5,iA6,iA7,iA8,iA9,iAA,iAB,iAC,iAD,iAE,iAF;
	reg [1023:0] iB0,iB1,iB2,iB3,iB4,iB5,iB6,iB7,iB8,iB9,iBA,iBB,iBC,iBD,iBE,iBF;
	reg [1023:0] iC0,iC1,iC2,iC3,iC4,iC5,iC6,iC7,iC8,iC9,iCA,iCB,iCC,iCD,iCE,iCF;

	wire [1023:0] o00,o01,o02,o03,o04,o05,o06,o07,o08,o09,o0A,o0B,o0C,o0D,o0E,o0F;
	wire [1023:0] o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o1A,o1B,o1C,o1D,o1E,o1F;
	wire [1023:0] o20,o21,o22,o23,o24,o25,o26,o27,o28,o29,o2A,o2B,o2C,o2D,o2E,o2F;
	wire [1023:0] o30,o31,o32,o33,o34,o35,o36,o37,o38,o39,o3A,o3B,o3C,o3D,o3E,o3F;
	wire [1023:0] o40,o41,o42,o43,o44,o45,o46,o47,o48,o49,o4A,o4B,o4C,o4D,o4E,o4F;
	wire [1023:0] o50,o51,o52,o53,o54,o55,o56,o57,o58,o59,o5A,o5B,o5C,o5D,o5E,o5F;
	wire [1023:0] o60,o61,o62,o63,o64,o65,o66,o67,o68,o69,o6A,o6B,o6C,o6D,o6E,o6F;
	wire [1023:0] o70,o71,o72,o73,o74,o75,o76,o77,o78,o79,o7A,o7B,o7C,o7D,o7E,o7F;
	wire [1023:0] o80,o81,o82,o83,o84,o85,o86,o87,o88,o89,o8A,o8B,o8C,o8D,o8E,o8F;
	wire [1023:0] o90,o91,o92,o93,o94,o95,o96,o97,o98,o99,o9A,o9B,o9C,o9D,o9E,o9F;
	wire [1023:0] oA0,oA1,oA2,oA3,oA4,oA5,oA6,oA7,oA8,oA9,oAA,oAB,oAC,oAD,oAE,oAF;
	wire [1023:0] oB0,oB1,oB2,oB3,oB4,oB5,oB6,oB7,oB8,oB9,oBA,oBB,oBC,oBD,oBE,oBF;
	wire [1023:0] oC0,oC1,oC2,oC3,oC4,oC5,oC6,oC7,oC8,oC9,oCA,oCB,oCC,oCD,oCE,oCF;

	// Round 0
	cube_test_round cr00 (i00, o00);
	cube_test_round cr01 (i01, o01);
	cube_test_round cr02 (i02, o02);
	cube_test_round cr03 (i03, o03);
	cube_test_round cr04 (i04, o04);
	cube_test_round cr05 (i05, o05);
	cube_test_round cr06 (i06, o06);
	cube_test_round cr07 (i07, o07);
	cube_test_round cr08 (i08, o08);
	cube_test_round cr09 (i09, o09);
	cube_test_round cr0A (i0A, o0A);
	cube_test_round cr0B (i0B, o0B);
	cube_test_round cr0C (i0C, o0C);
	cube_test_round cr0D (i0D, o0D);
	cube_test_round cr0E (i0E, o0E);
	cube_test_round cr0F (i0F, o0F);

	// Round 1
	cube_test_round cr10 (i10, o10);
	cube_test_round cr11 (i11, o11);
	cube_test_round cr12 (i12, o12);
	cube_test_round cr13 (i13, o13);
	cube_test_round cr14 (i14, o14);
	cube_test_round cr15 (i15, o15);
	cube_test_round cr16 (i16, o16);
	cube_test_round cr17 (i17, o17);
	cube_test_round cr18 (i18, o18);
	cube_test_round cr19 (i19, o19);
	cube_test_round cr1A (i1A, o1A);
	cube_test_round cr1B (i1B, o1B);
	cube_test_round cr1C (i1C, o1C);
	cube_test_round cr1D (i1D, o1D);
	cube_test_round cr1E (i1E, o1E);
	cube_test_round cr1F (i1F, o1F);

	// Round 2
	cube_test_round cr20 (i20, o20);
	cube_test_round cr21 (i21, o21);
	cube_test_round cr22 (i22, o22);
	cube_test_round cr23 (i23, o23);
	cube_test_round cr24 (i24, o24);
	cube_test_round cr25 (i25, o25);
	cube_test_round cr26 (i26, o26);
	cube_test_round cr27 (i27, o27);
	cube_test_round cr28 (i28, o28);
	cube_test_round cr29 (i29, o29);
	cube_test_round cr2A (i2A, o2A);
	cube_test_round cr2B (i2B, o2B);
	cube_test_round cr2C (i2C, o2C);
	cube_test_round cr2D (i2D, o2D);
	cube_test_round cr2E (i2E, o2E);
	cube_test_round cr2F (i2F, o2F);

	// Round 3
	cube_test_round cr30 (i30, o30);
	cube_test_round cr31 (i31, o31);
	cube_test_round cr32 (i32, o32);
	cube_test_round cr33 (i33, o33);
	cube_test_round cr34 (i34, o34);
	cube_test_round cr35 (i35, o35);
	cube_test_round cr36 (i36, o36);
	cube_test_round cr37 (i37, o37);
	cube_test_round cr38 (i38, o38);
	cube_test_round cr39 (i39, o39);
	cube_test_round cr3A (i3A, o3A);
	cube_test_round cr3B (i3B, o3B);
	cube_test_round cr3C (i3C, o3C);
	cube_test_round cr3D (i3D, o3D);
	cube_test_round cr3E (i3E, o3E);
	cube_test_round cr3F (i3F, o3F);

	// Round 4
	cube_test_round cr40 (i40, o40);
	cube_test_round cr41 (i41, o41);
	cube_test_round cr42 (i42, o42);
	cube_test_round cr43 (i43, o43);
	cube_test_round cr44 (i44, o44);
	cube_test_round cr45 (i45, o45);
	cube_test_round cr46 (i46, o46);
	cube_test_round cr47 (i47, o47);
	cube_test_round cr48 (i48, o48);
	cube_test_round cr49 (i49, o49);
	cube_test_round cr4A (i4A, o4A);
	cube_test_round cr4B (i4B, o4B);
	cube_test_round cr4C (i4C, o4C);
	cube_test_round cr4D (i4D, o4D);
	cube_test_round cr4E (i4E, o4E);
	cube_test_round cr4F (i4F, o4F);

	// Round 5
	cube_test_round cr50 (i50, o50);
	cube_test_round cr51 (i51, o51);
	cube_test_round cr52 (i52, o52);
	cube_test_round cr53 (i53, o53);
	cube_test_round cr54 (i54, o54);
	cube_test_round cr55 (i55, o55);
	cube_test_round cr56 (i56, o56);
	cube_test_round cr57 (i57, o57);
	cube_test_round cr58 (i58, o58);
	cube_test_round cr59 (i59, o59);
	cube_test_round cr5A (i5A, o5A);
	cube_test_round cr5B (i5B, o5B);
	cube_test_round cr5C (i5C, o5C);
	cube_test_round cr5D (i5D, o5D);
	cube_test_round cr5E (i5E, o5E);
	cube_test_round cr5F (i5F, o5F);

	// Round 6
	cube_test_round cr60 (i60, o60);
	cube_test_round cr61 (i61, o61);
	cube_test_round cr62 (i62, o62);
	cube_test_round cr63 (i63, o63);
	cube_test_round cr64 (i64, o64);
	cube_test_round cr65 (i65, o65);
	cube_test_round cr66 (i66, o66);
	cube_test_round cr67 (i67, o67);
	cube_test_round cr68 (i68, o68);
	cube_test_round cr69 (i69, o69);
	cube_test_round cr6A (i6A, o6A);
	cube_test_round cr6B (i6B, o6B);
	cube_test_round cr6C (i6C, o6C);
	cube_test_round cr6D (i6D, o6D);
	cube_test_round cr6E (i6E, o6E);
	cube_test_round cr6F (i6F, o6F);

	// Round 7
	cube_test_round cr70 (i70, o70);
	cube_test_round cr71 (i71, o71);
	cube_test_round cr72 (i72, o72);
	cube_test_round cr73 (i73, o73);
	cube_test_round cr74 (i74, o74);
	cube_test_round cr75 (i75, o75);
	cube_test_round cr76 (i76, o76);
	cube_test_round cr77 (i77, o77);
	cube_test_round cr78 (i78, o78);
	cube_test_round cr79 (i79, o79);
	cube_test_round cr7A (i7A, o7A);
	cube_test_round cr7B (i7B, o7B);
	cube_test_round cr7C (i7C, o7C);
	cube_test_round cr7D (i7D, o7D);
	cube_test_round cr7E (i7E, o7E);
	cube_test_round cr7F (i7F, o7F);

	// Round 8
	cube_test_round cr80 (i80, o80);
	cube_test_round cr81 (i81, o81);
	cube_test_round cr82 (i82, o82);
	cube_test_round cr83 (i83, o83);
	cube_test_round cr84 (i84, o84);
	cube_test_round cr85 (i85, o85);
	cube_test_round cr86 (i86, o86);
	cube_test_round cr87 (i87, o87);
	cube_test_round cr88 (i88, o88);
	cube_test_round cr89 (i89, o89);
	cube_test_round cr8A (i8A, o8A);
	cube_test_round cr8B (i8B, o8B);
	cube_test_round cr8C (i8C, o8C);
	cube_test_round cr8D (i8D, o8D);
	cube_test_round cr8E (i8E, o8E);
	cube_test_round cr8F (i8F, o8F);

	// Round 9
	cube_test_round cr90 (i90, o90);
	cube_test_round cr91 (i91, o91);
	cube_test_round cr92 (i92, o92);
	cube_test_round cr93 (i93, o93);
	cube_test_round cr94 (i94, o94);
	cube_test_round cr95 (i95, o95);
	cube_test_round cr96 (i96, o96);
	cube_test_round cr97 (i97, o97);
	cube_test_round cr98 (i98, o98);
	cube_test_round cr99 (i99, o99);
	cube_test_round cr9A (i9A, o9A);
	cube_test_round cr9B (i9B, o9B);
	cube_test_round cr9C (i9C, o9C);
	cube_test_round cr9D (i9D, o9D);
	cube_test_round cr9E (i9E, o9E);
	cube_test_round cr9F (i9F, o9F);

	// Round 10
	cube_test_round crA0 (iA0, oA0);
	cube_test_round crA1 (iA1, oA1);
	cube_test_round crA2 (iA2, oA2);
	cube_test_round crA3 (iA3, oA3);
	cube_test_round crA4 (iA4, oA4);
	cube_test_round crA5 (iA5, oA5);
	cube_test_round crA6 (iA6, oA6);
	cube_test_round crA7 (iA7, oA7);
	cube_test_round crA8 (iA8, oA8);
	cube_test_round crA9 (iA9, oA9);
	cube_test_round crAA (iAA, oAA);
	cube_test_round crAB (iAB, oAB);
	cube_test_round crAC (iAC, oAC);
	cube_test_round crAD (iAD, oAD);
	cube_test_round crAE (iAE, oAE);
	cube_test_round crAF (iAF, oAF);

	// Round 11
	cube_test_round crB0 (iB0, oB0);
	cube_test_round crB1 (iB1, oB1);
	cube_test_round crB2 (iB2, oB2);
	cube_test_round crB3 (iB3, oB3);
	cube_test_round crB4 (iB4, oB4);
	cube_test_round crB5 (iB5, oB5);
	cube_test_round crB6 (iB6, oB6);
	cube_test_round crB7 (iB7, oB7);
	cube_test_round crB8 (iB8, oB8);
	cube_test_round crB9 (iB9, oB9);
	cube_test_round crBA (iBA, oBA);
	cube_test_round crBB (iBB, oBB);
	cube_test_round crBC (iBC, oBC);
	cube_test_round crBD (iBD, oBD);
	cube_test_round crBE (iBE, oBE);
	cube_test_round crBF (iBF, oBF);
	
	// Round 12
	cube_test_round crC0 (iC0, oC0);
	cube_test_round crC1 (iC1, oC1);
	cube_test_round crC2 (iC2, oC2);
	cube_test_round crC3 (iC3, oC3);
	cube_test_round crC4 (iC4, oC4);
	cube_test_round crC5 (iC5, oC5);
	cube_test_round crC6 (iC6, oC6);
	cube_test_round crC7 (iC7, oC7);
	cube_test_round crC8 (iC8, oC8);
	cube_test_round crC9 (iC9, oC9);
	cube_test_round crCA (iCA, oCA);
	cube_test_round crCB (iCB, oCB);
	cube_test_round crCC (iCC, oCC);
	cube_test_round crCD (iCD, oCD);
	cube_test_round crCE (iCE, oCE);
	cube_test_round crCF (iCF, oCF);

	
	always @ (posedge clk) begin
		
		i00 = 1024'h2AEA2A6150F494D42D538B8B4167D83E3FEE2313C701CF8CCC39968E50AC56954D42C787A647A8B397CF0BEF825B4537EEF864D2F22090C4D0E5CD33A23911AEFCD398D9148FE4851B017BEFB64445326A5361592FF5781C91FA79340DBADEA9D65C8A2BA5A70E75B1C62456BC7965761921C8F7E7989AF17795D246D43E3B44;
		i00[1023:992] = i00[1023:992] ^ data_le[  0 +: 32];
		i00[991:960] = i00[991:960] ^ data_le[ 32 +: 32];
		i00[959:928] = i00[959:928] ^ data_le[ 64 +: 32];
		i00[927:896] = i00[927:896] ^ data_le[ 96 +: 32];
		i00[895:864] = i00[895:864] ^ data_le[128 +: 32];
		i00[863:832] = i00[863:832] ^ data_le[160 +: 32];
		i00[831:800] = i00[831:800] ^ data_le[192 +: 32];
		i00[799:768] = i00[799:768] ^ data_le[224 +: 32];
		i01 = o00;
		i02 = o01;
		i03 = o02;
		i04 = o03;
		i05 = o04;
		i06 = o05;
		i07 = o06;
		i08 = o07;
		i09 = o08;
		i0A = o09;
		i0B = o0A;
		i0C = o0B;
		i0D = o0C;
		i0E = o0D;
		i0F = o0E;
				
		i10 = o0F;
		i10[1023:992] = i10[1023:992] ^ data_le[256 +: 32];
		i10[991:960] = i10[991:960] ^ data_le[288 +: 32];
		i10[959:928] = i10[959:928] ^ data_le[320 +: 32];
		i10[927:896] = i10[927:896] ^ data_le[352 +: 32];
		i10[895:864] = i10[895:864] ^ data_le[384 +: 32];
		i10[863:832] = i10[863:832] ^ data_le[416 +: 32];
		i10[831:800] = i10[831:800] ^ data_le[448 +: 32];
		i10[799:768] = i10[799:768] ^ data_le[480 +: 32];
		i11 = o10;
		i12 = o11;
		i13 = o12;
		i14 = o13;
		i15 = o14;
		i16 = o15;
		i17 = o16;
		i18 = o17;
		i19 = o18;
		i1A = o19;
		i1B = o1A;
		i1C = o1B;
		i1D = o1C;
		i1E = o1D;
		i1F = o1E;
				
		i20 = o1F;
		i20[1023:992] = i20[1023:992] ^ 32'h80;
		i21 = o20;
		i22 = o21;
		i23 = o22;
		i24 = o23;
		i25 = o24;
		i26 = o25;
		i27 = o26;
		i28 = o27;
		i29 = o28;
		i2A = o29;
		i2B = o2A;
		i2C = o2B;
		i2D = o2C;
		i2E = o2D;
		i2F = o2E;
				
		i30 = o2F;
		i30[31:0] = i30[31:0] ^ 32'h1;
		i31 = o30;
		i32 = o31;
		i33 = o32;
		i34 = o33;
		i35 = o34;
		i36 = o35;
		i37 = o36;
		i38 = o37;
		i39 = o38;
		i3A = o39;
		i3B = o3A;
		i3C = o3B;
		i3D = o3C;
		i3E = o3D;
		i3F = o3E;
				
		i40 = o3F;
		i41 = o40;
		i42 = o41;
		i43 = o42;
		i44 = o43;
		i45 = o44;
		i46 = o45;
		i47 = o46;
		i48 = o47;
		i49 = o48;
		i4A = o49;
		i4B = o4A;
		i4C = o4B;
		i4D = o4C;
		i4E = o4D;
		i4F = o4E;
				
		i50 = o4F;
		i51 = o50;
		i52 = o51;
		i53 = o52;
		i54 = o53;
		i55 = o54;
		i56 = o55;
		i57 = o56;
		i58 = o57;
		i59 = o58;
		i5A = o59;
		i5B = o5A;
		i5C = o5B;
		i5D = o5C;
		i5E = o5D;
		i5F = o5E;
				
		i60 = o5F;
		i61 = o60;
		i62 = o61;
		i63 = o62;
		i64 = o63;
		i65 = o64;
		i66 = o65;
		i67 = o66;
		i68 = o67;
		i69 = o68;
		i6A = o69;
		i6B = o6A;
		i6C = o6B;
		i6D = o6C;
		i6E = o6D;
		i6F = o6E;
				
		i70 = o6F;
		i71 = o70;
		i72 = o71;
		i73 = o72;
		i74 = o73;
		i75 = o74;
		i76 = o75;
		i77 = o76;
		i78 = o77;
		i79 = o78;
		i7A = o79;
		i7B = o7A;
		i7C = o7B;
		i7D = o7C;
		i7E = o7D;
		i7F = o7E;
				
		i80 = o7F;
		i81 = o80;
		i82 = o81;
		i83 = o82;
		i84 = o83;
		i85 = o84;
		i86 = o85;
		i87 = o86;
		i88 = o87;
		i89 = o88;
		i8A = o89;
		i8B = o8A;
		i8C = o8B;
		i8D = o8C;
		i8E = o8D;
		i8F = o8E;
				
		i90 = o8F;
		i91 = o90;
		i92 = o91;
		i93 = o92;
		i94 = o93;
		i95 = o94;
		i96 = o95;
		i97 = o96;
		i98 = o97;
		i99 = o98;
		i9A = o99;
		i9B = o9A;
		i9C = o9B;
		i9D = o9C;
		i9E = o9D;
		i9F = o9E;
				
		iA0 = o9F;
		iA1 = oA0;
		iA2 = oA1;
		iA3 = oA2;
		iA4 = oA3;
		iA5 = oA4;
		iA6 = oA5;
		iA7 = oA6;
		iA8 = oA7;
		iA9 = oA8;
		iAA = oA9;
		iAB = oAA;
		iAC = oAB;
		iAD = oAC;
		iAE = oAD;
		iAF = oAE;
				
		iB0 = oAF;
		iB1 = oB0;
		iB2 = oB1;
		iB3 = oB2;
		iB4 = oB3;
		iB5 = oB4;
		iB6 = oB5;
		iB7 = oB6;
		iB8 = oB7;
		iB9 = oB8;
		iBA = oB9;
		iBB = oBA;
		iBC = oBB;
		iBD = oBC;
		iBE = oBD;
		iBF = oBE;

		iC0 = oBF;
		iC1 = oC0;
		iC2 = oC1;
		iC3 = oC2;
		iC4 = oC3;
		iC5 = oC4;
		iC6 = oC5;
		iC7 = oC6;
		iC8 = oC7;
		iC9 = oC8;
		iCA = oC9;
		iCB = oCA;
		iCC = oCB;
		iCD = oCC;
		iCE = oCD;
		iCF = oCE;

		hash_le = {
			oCF[543:512],
			oCF[575:544],
			oCF[607:576],
			oCF[639:608],
			oCF[671:640],
			oCF[703:672],
			oCF[735:704],
			oCF[767:736],
			oCF[799:768],
			oCF[831:800],
			oCF[863:832],
			oCF[895:864],
			oCF[927:896],
			oCF[959:928],
			oCF[991:960],
			oCF[1023:992] };
			
	end

endmodule

(* DONT_TOUCH = "true" *) module cube_test_round (
	input [1023:0] Rin,
	output [1023:0] Rout
);

	wire [31:0] Rin0, Rin1, Rin2, Rin3, Rin4, Rin5, Rin6, Rin7; 
	wire [31:0] Rin8, Rin9, Rin10, Rin11, Rin12, Rin13, Rin14, Rin15;
	wire [31:0] Rin16, Rin17, Rin18, Rin19, Rin20, Rin21, Rin22, Rin23;
	wire [31:0] Rin24, Rin25, Rin26, Rin27, Rin28, Rin29, Rin30, Rin31;

	wire [31:0] rot7_0, rot7_1, rot7_2, rot7_3, rot7_4, rot7_5, rot7_6, rot7_7; 
	wire [31:0] rot7_8, rot7_9, rot7_10, rot7_11, rot7_12, rot7_13, rot7_14, rot7_15;

	wire [31:0] add0_16, add0_17, add0_18, add0_19, add0_20, add0_21, add0_22, add0_23;
	wire [31:0] add0_24, add0_25, add0_26, add0_27, add0_28, add0_29, add0_30, add0_31;

	wire [31:0] add1_16, add1_17, add1_18, add1_19, add1_20, add1_21, add1_22, add1_23;
	wire [31:0] add1_24, add1_25, add1_26, add1_27, add1_28, add1_29, add1_30, add1_31;

	wire [31:0] rot11_0, rot11_1, rot11_2, rot11_3, rot11_4, rot11_5, rot11_6, rot11_7; 
	wire [31:0] rot11_8, rot11_9, rot11_10, rot11_11, rot11_12, rot11_13, rot11_14, rot11_15;

	wire [31:0] swap0_0, swap0_1, swap0_2, swap0_3, swap0_4, swap0_5, swap0_6, swap0_7; 
	wire [31:0] swap0_8, swap0_9, swap0_10, swap0_11, swap0_12, swap0_13, swap0_14, swap0_15;

	wire [31:0] swap1_16, swap1_17, swap1_18, swap1_19, swap1_20, swap1_21, swap1_22, swap1_23;
	wire [31:0] swap1_24, swap1_25, swap1_26, swap1_27, swap1_28, swap1_29, swap1_30, swap1_31;

	wire [31:0] swap2_0, swap2_1, swap2_2, swap2_3, swap2_4, swap2_5, swap2_6, swap2_7; 
	wire [31:0] swap2_8, swap2_9, swap2_10, swap2_11, swap2_12, swap2_13, swap2_14, swap2_15;

	wire [31:0] swap3_16, swap3_17, swap3_18, swap3_19, swap3_20, swap3_21, swap3_22, swap3_23;
	wire [31:0] swap3_24, swap3_25, swap3_26, swap3_27, swap3_28, swap3_29, swap3_30, swap3_31;

	wire [31:0] Xor0_0, Xor0_1, Xor0_2, Xor0_3, Xor0_4, Xor0_5, Xor0_6, Xor0_7; 
	wire [31:0] Xor0_8, Xor0_9, Xor0_10, Xor0_11, Xor0_12, Xor0_13, Xor0_14, Xor0_15;

	wire [31:0] Xor1_0, Xor1_1, Xor1_2, Xor1_3, Xor1_4, Xor1_5, Xor1_6, Xor1_7; 
	wire [31:0] Xor1_8, Xor1_9, Xor1_10, Xor1_11, Xor1_12, Xor1_13, Xor1_14, Xor1_15;

	// Rin
	assign Rin0 = Rin[1023:992];
	assign Rin1 = Rin[991:960];
	assign Rin2 = Rin[959:928];
	assign Rin3 = Rin[927:896];
	assign Rin4 = Rin[895:864];
	assign Rin5 = Rin[863:832];
	assign Rin6 = Rin[831:800];
	assign Rin7 = Rin[799:768];
	assign Rin8 = Rin[767:736];
	assign Rin9 = Rin[735:704];
	assign Rin10 = Rin[703:672];
	assign Rin11 = Rin[671:640];
	assign Rin12 = Rin[639:608];
	assign Rin13 = Rin[607:576];
	assign Rin14 = Rin[575:544];
	assign Rin15 = Rin[543:512];
	assign Rin16 = Rin[511:480];
	assign Rin17 = Rin[479:448];
	assign Rin18 = Rin[447:416];
	assign Rin19 = Rin[415:384];
	assign Rin20 = Rin[383:352];
	assign Rin21 = Rin[351:320];
	assign Rin22 = Rin[319:288];
	assign Rin23 = Rin[287:256];
	assign Rin24 = Rin[255:224];
	assign Rin25 = Rin[223:192];
	assign Rin26 = Rin[191:160];
	assign Rin27 = Rin[159:128];
	assign Rin28 = Rin[127:96];
	assign Rin29 = Rin[95:64];
	assign Rin30 = Rin[63:32];
	assign Rin31 = Rin[31:0];

	// Rout
	assign Rout = {Xor1_0, Xor1_1, Xor1_2, Xor1_3, Xor1_4, Xor1_5, Xor1_6, Xor1_7,
		Xor1_8, Xor1_9, Xor1_10, Xor1_11, Xor1_12, Xor1_13, Xor1_14, Xor1_15,
		swap3_16, swap3_17, swap3_18, swap3_19, swap3_20, swap3_21, swap3_22, swap3_23, swap3_24,
		swap3_25, swap3_26, swap3_27, swap3_28, swap3_29, swap3_30, swap3_31};

	// add 0 
	adder32 a0 ( Rin0, Rin16, add0_16 ); 
	adder32 a1 ( Rin1, Rin17, add0_17 ); 
	adder32 a2 ( Rin2, Rin18, add0_18 ); 
	adder32 a3 ( Rin3, Rin19, add0_19 ); 
	adder32 a4 ( Rin4, Rin20, add0_20 ); 
	adder32 a5 ( Rin5, Rin21, add0_21 ); 
	adder32 a6 ( Rin6, Rin22, add0_22 ); 
	adder32 a7 ( Rin7, Rin23, add0_23 ); 
	adder32 a8 ( Rin8, Rin24, add0_24 ); 
	adder32 a9 ( Rin9, Rin25, add0_25 ); 
	adder32 aA ( Rin10, Rin26, add0_26 ); 
	adder32 aB ( Rin11, Rin27, add0_27 ); 
	adder32 aC ( Rin12, Rin28, add0_28 ); 
	adder32 aD ( Rin13, Rin29, add0_29 ); 
	adder32 aE ( Rin14, Rin30, add0_30 ); 
	adder32 aF ( Rin15, Rin31, add0_31 ); 

//	assign add0_16 = Rin0 + Rin16;
//	assign add0_17 = Rin1 + Rin17;
//	assign add0_18 = Rin2 + Rin18;
//	assign add0_19 = Rin3 + Rin19;
//	assign add0_20 = Rin4 + Rin20;
//	assign add0_21 = Rin5 + Rin21;
//	assign add0_22 = Rin6 + Rin22;
//	assign add0_23 = Rin7 + Rin23;
//	assign add0_24 = Rin8 + Rin24;
//	assign add0_25 = Rin9 + Rin25;
//	assign add0_26 = Rin10 + Rin26;
//	assign add0_27 = Rin11 + Rin27;
//	assign add0_28 = Rin12 + Rin28;
//	assign add0_29 = Rin13 + Rin29;
//	assign add0_30 = Rin14 + Rin30;
//	assign add0_31 = Rin15 + Rin31;


	// rot7
	assign rot7_0 = {Rin0[24:0],Rin0[31:25]};
	assign rot7_1 = {Rin1[24:0],Rin1[31:25]};
	assign rot7_2 = {Rin2[24:0],Rin2[31:25]};
	assign rot7_3 = {Rin3[24:0],Rin3[31:25]};
	assign rot7_4 = {Rin4[24:0],Rin4[31:25]};
	assign rot7_5 = {Rin5[24:0],Rin5[31:25]};
	assign rot7_6 = {Rin6[24:0],Rin6[31:25]};
	assign rot7_7 = {Rin7[24:0],Rin7[31:25]};
	assign rot7_8 = {Rin8[24:0],Rin8[31:25]};
	assign rot7_9 = {Rin9[24:0],Rin9[31:25]};
	assign rot7_10 = {Rin10[24:0],Rin10[31:25]};
	assign rot7_11 = {Rin11[24:0],Rin11[31:25]};
	assign rot7_12 = {Rin12[24:0],Rin12[31:25]};
	assign rot7_13 = {Rin13[24:0],Rin13[31:25]};
	assign rot7_14 = {Rin14[24:0],Rin14[31:25]};
	assign rot7_15 = {Rin15[24:0],Rin15[31:25]};

	// swap 0
	assign swap0_0 = rot7_8;
	assign swap0_1 = rot7_9;
	assign swap0_2 = rot7_10;
	assign swap0_3 = rot7_11;
	assign swap0_4 = rot7_12;
	assign swap0_5 = rot7_13;
	assign swap0_6 = rot7_14;
	assign swap0_7 = rot7_15;
	assign swap0_8 = rot7_0;
	assign swap0_9 = rot7_1;
	assign swap0_10 = rot7_2;
	assign swap0_11 = rot7_3;
	assign swap0_12 = rot7_4;
	assign swap0_13 = rot7_5;
	assign swap0_14 = rot7_6;
	assign swap0_15 = rot7_7;

	// Xor 0
	assign Xor0_0 = swap0_0 ^ add0_16; 
	assign Xor0_1 = swap0_1 ^ add0_17; 
	assign Xor0_2 = swap0_2 ^ add0_18; 
	assign Xor0_3 = swap0_3 ^ add0_19; 
	assign Xor0_4 = swap0_4 ^ add0_20; 
	assign Xor0_5 = swap0_5 ^ add0_21; 
	assign Xor0_6 = swap0_6 ^ add0_22; 
	assign Xor0_7 = swap0_7 ^ add0_23; 
	assign Xor0_8 = swap0_8 ^ add0_24; 
	assign Xor0_9 = swap0_9 ^ add0_25; 
	assign Xor0_10 = swap0_10 ^ add0_26; 
	assign Xor0_11 = swap0_11 ^ add0_27; 
	assign Xor0_12 = swap0_12 ^ add0_28; 
	assign Xor0_13 = swap0_13 ^ add0_29; 
	assign Xor0_14 = swap0_14 ^ add0_30; 
	assign Xor0_15 = swap0_15 ^ add0_31; 

	// swap 1
	assign swap1_16 = add0_18;
	assign swap1_17 = add0_19;
	assign swap1_18 = add0_16;
	assign swap1_19 = add0_17;
	assign swap1_20 = add0_22;
	assign swap1_21 = add0_23;
	assign swap1_22 = add0_20;
	assign swap1_23 = add0_21;
	assign swap1_24 = add0_26;
	assign swap1_25 = add0_27;
	assign swap1_26 = add0_24;
	assign swap1_27 = add0_25;
	assign swap1_28 = add0_30;
	assign swap1_29 = add0_31;
	assign swap1_30 = add0_28;
	assign swap1_31 = add0_29;

	// add 1 
	assign add1_16 = Xor0_0 + swap1_16;
	assign add1_17 = Xor0_1 + swap1_17;
	assign add1_18 = Xor0_2 + swap1_18;
	assign add1_19 = Xor0_3 + swap1_19;
	assign add1_20 = Xor0_4 + swap1_20;
	assign add1_21 = Xor0_5 + swap1_21;
	assign add1_22 = Xor0_6 + swap1_22;
	assign add1_23 = Xor0_7 + swap1_23;
	assign add1_24 = Xor0_8 + swap1_24;
	assign add1_25 = Xor0_9 + swap1_25;
	assign add1_26 = Xor0_10 + swap1_26;
	assign add1_27 = Xor0_11 + swap1_27;
	assign add1_28 = Xor0_12 + swap1_28;
	assign add1_29 = Xor0_13 + swap1_29;
	assign add1_30 = Xor0_14 + swap1_30;
	assign add1_31 = Xor0_15 + swap1_31;

	// rot1 1
	assign rot11_0 = {Xor0_0[20:0],Xor0_0[31:21]};
	assign rot11_1 = {Xor0_1[20:0],Xor0_1[31:21]};
	assign rot11_2 = {Xor0_2[20:0],Xor0_2[31:21]};
	assign rot11_3 = {Xor0_3[20:0],Xor0_3[31:21]};
	assign rot11_4 = {Xor0_4[20:0],Xor0_4[31:21]};
	assign rot11_5 = {Xor0_5[20:0],Xor0_5[31:21]};
	assign rot11_6 = {Xor0_6[20:0],Xor0_6[31:21]};
	assign rot11_7 = {Xor0_7[20:0],Xor0_7[31:21]};
	assign rot11_8 = {Xor0_8[20:0],Xor0_8[31:21]};
	assign rot11_9 = {Xor0_9[20:0],Xor0_9[31:21]};
	assign rot11_10 = {Xor0_10[20:0],Xor0_10[31:21]};
	assign rot11_11 = {Xor0_11[20:0],Xor0_11[31:21]};
	assign rot11_12 = {Xor0_12[20:0],Xor0_12[31:21]};
	assign rot11_13 = {Xor0_13[20:0],Xor0_13[31:21]};
	assign rot11_14 = {Xor0_14[20:0],Xor0_14[31:21]};
	assign rot11_15 = {Xor0_15[20:0],Xor0_15[31:21]};

	// swap 2
	assign swap2_0 = rot11_4;
	assign swap2_1 = rot11_5;
	assign swap2_2 = rot11_6;
	assign swap2_3 = rot11_7;
	assign swap2_4 = rot11_0;
	assign swap2_5 = rot11_1;
	assign swap2_6 = rot11_2;
	assign swap2_7 = rot11_3;
	assign swap2_8 = rot11_12;
	assign swap2_9 = rot11_13;
	assign swap2_10 = rot11_14;
	assign swap2_11 = rot11_15;
	assign swap2_12 = rot11_8;
	assign swap2_13 = rot11_9;
	assign swap2_14 = rot11_10;
	assign swap2_15 = rot11_11;

	// Xor 1
	assign Xor1_0 = swap2_0 ^ add1_16; 
	assign Xor1_1 = swap2_1 ^ add1_17; 
	assign Xor1_2 = swap2_2 ^ add1_18; 
	assign Xor1_3 = swap2_3 ^ add1_19; 
	assign Xor1_4 = swap2_4 ^ add1_20; 
	assign Xor1_5 = swap2_5 ^ add1_21; 
	assign Xor1_6 = swap2_6 ^ add1_22; 
	assign Xor1_7 = swap2_7 ^ add1_23; 
	assign Xor1_8 = swap2_8 ^ add1_24; 
	assign Xor1_9 = swap2_9 ^ add1_25; 
	assign Xor1_10 = swap2_10 ^ add1_26; 
	assign Xor1_11 = swap2_11 ^ add1_27; 
	assign Xor1_12 = swap2_12 ^ add1_28; 
	assign Xor1_13 = swap2_13 ^ add1_29; 
	assign Xor1_14 = swap2_14 ^ add1_30; 
	assign Xor1_15 = swap2_15 ^ add1_31; 

	// swap 3
	assign swap3_16 = add1_17;
	assign swap3_17 = add1_16;
	assign swap3_18 = add1_19;
	assign swap3_19 = add1_18;
	assign swap3_20 = add1_21;
	assign swap3_21 = add1_20;
	assign swap3_22 = add1_23;
	assign swap3_23 = add1_22;
	assign swap3_24 = add1_25;
	assign swap3_25 = add1_24;
	assign swap3_26 = add1_27;
	assign swap3_27 = add1_26;
	assign swap3_28 = add1_29;
	assign swap3_29 = add1_28;
	assign swap3_30 = add1_31;
	assign swap3_31 = add1_30;

endmodule

//(* DONT_TOUCH = "true" *) module adder32 (
//	(* DONT_TOUCH = "true" *) input [31:0] a,
//	(* DONT_TOUCH = "true" *) input [31:0] b,
//	(* DONT_TOUCH = "true" *) output [31:0] c
//);
//
//	(* DONT_TOUCH = "true" *) wire [31:0] d;
//	
//	assign d = a + b;
//	assign c = d;
////	assign c = a + b;
//
////   wire [32:0] sum = {1'b0,a} + {1'b0,b};
////   assign c = sum[32] ? sum[32:1]: sum[31:0];
//	
//endmodule


///////////////////////////////////////////////
//
// This is a standard Full Adder cell expressed
// in a WYSIWYG gate.  This form is preferable
// to comb logic because it explicitly marks the
// carry in and carry out.  It is also a good
// way to express complex logic functions on the 
// input side of the adder, and shared chains 
// (ternary addition).   This view gives access
// to all architecture capabilities, but is somewhat
// cumbersome to use.  Unlike the "+" operator
// a WYSIWYG add will not be restructured or 
// mimnimized except in extreme cases.
//
module full_add (a,b,cin,s,cout);
input a,b,cin;
output s,cout;

stratixii_lcell_comb w (
    .dataa(1'b1),
    .datab(1'b1),
    .datac(1'b1),
    .datad(a),
    .datae(1'b1),
    .dataf(b),
    .datag(1'b1),

    .cin(cin),
    .sharein(1'b0),
    .sumout(s),
    .cout(cout),
    .combout(),
    .shareout()
);

defparam w .shared_arith = "off";
defparam w .extended_lut = "off";
defparam w .lut_mask = 64'h000000ff0000ff00 ;

//
// Note : LUT mask programming is generally done by
//   synthesis software, but they can be set by hand.  This
//   explanation is for the interested person, and by 
//   no means necessary to follow.
//
// The lut mask is a truth table expressed in 64 bit hex.  
// In basic adder mode these two blocks are active.
//         vvvv    vvvv 
// 64'h000000ff0000ff00 
// 
// Each 4 hex digit block represents a function of up to 4 inputs.
// The left hand block uses "ABCF" and the right hand "ABCD" with
// A being the least significant.  For each of the 16 possible input
// values the function output is stored in the corresponting bit.
//
//    e.g.  ffff  = vcc  (all ones)
//			ff00  = "D"  (most significant)
//			aaaa  = "A"  (1010..binary, the least significant)
//          6666  = "A xor B"
//
// These functions will be the two inputs to the adder chain.  
// In this case the inputs D and F pass through.  Detailed
// information on the programming of WYSIWYG cells is available
// through the Altera University Program (for CAD tools
// research).  
//

endmodule

///////////////////////////////////////////////
//
// This is a word adder constructed from the 
// slices declared above.
//
module adder32 (a,b,s);
parameter WIDTH = 32;

input [WIDTH-1:0] a,b;
output [WIDTH-1:0] s;
wire [WIDTH:0] cin;

assign cin[0] = 1'b0;

genvar i;
generate
	for (i=0; i<WIDTH; i=i+1) 
	begin : al
		full_add fa (.a(a[i]),.b(b[i]),.cin(cin[i]),.s(s[i]),.cout(cin[i+1]));
	end
endgenerate

endmodule
