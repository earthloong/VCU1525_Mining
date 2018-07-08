/*
 * Copyright (c) 2016 Sprocket
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

module permutation_q (
	input  clk,
	input  [3:0] round,
	input  [1023:0] in,
	output [1023:0] out
);

	reg [1023:0] t0, t1;

	(* ram_style = "block" *) wire [7:0] s_box [0:255] = {
		8'h63, 8'h7C, 8'h77, 8'h7B, 8'hF2, 8'h6B, 8'h6F, 8'hC5, 8'h30, 8'h01, 8'h67, 8'h2B, 8'hFE, 8'hD7, 8'hAB, 8'h76, 
		8'hCA, 8'h82, 8'hC9, 8'h7D, 8'hFA, 8'h59, 8'h47, 8'hF0, 8'hAD, 8'hD4, 8'hA2, 8'hAF, 8'h9C, 8'hA4, 8'h72, 8'hC0, 
		8'hB7, 8'hFD, 8'h93, 8'h26, 8'h36, 8'h3F, 8'hF7, 8'hCC, 8'h34, 8'hA5, 8'hE5, 8'hF1, 8'h71, 8'hD8, 8'h31, 8'h15, 
		8'h04, 8'hC7, 8'h23, 8'hC3, 8'h18, 8'h96, 8'h05, 8'h9A, 8'h07, 8'h12, 8'h80, 8'hE2, 8'hEB, 8'h27, 8'hB2, 8'h75, 
		8'h09, 8'h83, 8'h2C, 8'h1A, 8'h1B, 8'h6E, 8'h5A, 8'hA0, 8'h52, 8'h3B, 8'hD6, 8'hB3, 8'h29, 8'hE3, 8'h2F, 8'h84, 
		8'h53, 8'hD1, 8'h00, 8'hED, 8'h20, 8'hFC, 8'hB1, 8'h5B, 8'h6A, 8'hCB, 8'hBE, 8'h39, 8'h4A, 8'h4C, 8'h58, 8'hCF, 
		8'hD0, 8'hEF, 8'hAA, 8'hFB, 8'h43, 8'h4D, 8'h33, 8'h85, 8'h45, 8'hF9, 8'h02, 8'h7F, 8'h50, 8'h3C, 8'h9F, 8'hA8, 
		8'h51, 8'hA3, 8'h40, 8'h8F, 8'h92, 8'h9D, 8'h38, 8'hF5, 8'hBC, 8'hB6, 8'hDA, 8'h21, 8'h10, 8'hFF, 8'hF3, 8'hD2, 
		8'hCD, 8'h0C, 8'h13, 8'hEC, 8'h5F, 8'h97, 8'h44, 8'h17, 8'hC4, 8'hA7, 8'h7E, 8'h3D, 8'h64, 8'h5D, 8'h19, 8'h73, 
		8'h60, 8'h81, 8'h4F, 8'hDC, 8'h22, 8'h2A, 8'h90, 8'h88, 8'h46, 8'hEE, 8'hB8, 8'h14, 8'hDE, 8'h5E, 8'h0B, 8'hDB, 
		8'hE0, 8'h32, 8'h3A, 8'h0A, 8'h49, 8'h06, 8'h24, 8'h5C, 8'hC2, 8'hD3, 8'hAC, 8'h62, 8'h91, 8'h95, 8'hE4, 8'h79, 
		8'hE7, 8'hC8, 8'h37, 8'h6D, 8'h8D, 8'hD5, 8'h4E, 8'hA9, 8'h6C, 8'h56, 8'hF4, 8'hEA, 8'h65, 8'h7A, 8'hAE, 8'h08, 
		8'hBA, 8'h78, 8'h25, 8'h2E, 8'h1C, 8'hA6, 8'hB4, 8'hC6, 8'hE8, 8'hDD, 8'h74, 8'h1F, 8'h4B, 8'hBD, 8'h8B, 8'h8A, 
		8'h70, 8'h3E, 8'hB5, 8'h66, 8'h48, 8'h03, 8'hF6, 8'h0E, 8'h61, 8'h35, 8'h57, 8'hB9, 8'h86, 8'hC1, 8'h1D, 8'h9E, 
		8'hE1, 8'hF8, 8'h98, 8'h11, 8'h69, 8'hD9, 8'h8E, 8'h94, 8'h9B, 8'h1E, 8'h87, 8'hE9, 8'hCE, 8'h55, 8'h28, 8'hDF, 
		8'h8C, 8'hA1, 8'h89, 8'h0D, 8'hBF, 8'hE6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2D, 8'h0F, 8'hB0, 8'h54, 8'hBB, 8'h16
	};

	always @ (*) begin

		t0[1023:1016] <= s_box[in[952 +: 8]];
		t0[1015:1008] <= s_box[in[816 +: 8]];
		t0[1007:1000] <= s_box[in[680 +: 8]];
		t0[999:992] <= s_box[in[288 +: 8]];
		t0[991:984] <= s_box[in[984 +: 8]];
		t0[983:976] <= s_box[in[848 +: 8]];
		t0[975:968] <= s_box[in[712 +: 8]];
		t0[967:960] <= s_box[~in[576 +: 8] ^ { 4'h9, round } ];
		t0[959:952] <= s_box[in[888 +: 8]];
		t0[951:944] <= s_box[in[752 +: 8]];
		t0[943:936] <= s_box[in[616 +: 8]];
		t0[935:928] <= s_box[in[224 +: 8]];
		t0[927:920] <= s_box[in[920 +: 8]];
		t0[919:912] <= s_box[in[784 +: 8]];
		t0[911:904] <= s_box[in[648 +: 8]];
		t0[903:896] <= s_box[~in[512 +: 8] ^ { 4'h8, round } ];
		t0[895:888] <= s_box[in[824 +: 8]];
		t0[887:880] <= s_box[in[688 +: 8]];
		t0[879:872] <= s_box[in[552 +: 8]];
		t0[871:864] <= s_box[in[160 +: 8]];
		t0[863:856] <= s_box[in[856 +: 8]];
		t0[855:848] <= s_box[in[720 +: 8]];
		t0[847:840] <= s_box[in[584 +: 8]];
		t0[839:832] <= s_box[~in[448 +: 8] ^ { 4'h7, round } ];
		t0[831:824] <= s_box[in[760 +: 8]];
		t0[823:816] <= s_box[in[624 +: 8]];
		t0[815:808] <= s_box[in[488 +: 8]];
		t0[807:800] <= s_box[in[96 +: 8]];
		t0[799:792] <= s_box[in[792 +: 8]];
		t0[791:784] <= s_box[in[656 +: 8]];
		t0[783:776] <= s_box[in[520 +: 8]];
		t0[775:768] <= s_box[~in[384 +: 8] ^ { 4'h6, round } ];
		t0[767:760] <= s_box[in[696 +: 8]];
		t0[759:752] <= s_box[in[560 +: 8]];
		t0[751:744] <= s_box[in[424 +: 8]];
		t0[743:736] <= s_box[in[32 +: 8]];
		t0[735:728] <= s_box[in[728 +: 8]];
		t0[727:720] <= s_box[in[592 +: 8]];
		t0[719:712] <= s_box[in[456 +: 8]];
		t0[711:704] <= s_box[~in[320 +: 8] ^ { 4'h5, round } ];
		t0[703:696] <= s_box[in[632 +: 8]];
		t0[695:688] <= s_box[in[496 +: 8]];
		t0[687:680] <= s_box[in[360 +: 8]];
		t0[679:672] <= s_box[in[992 +: 8]];
		t0[671:664] <= s_box[in[664 +: 8]];
		t0[663:656] <= s_box[in[528 +: 8]];
		t0[655:648] <= s_box[in[392 +: 8]];
		t0[647:640] <= s_box[~in[256 +: 8] ^ { 4'h4, round } ];
		t0[639:632] <= s_box[in[568 +: 8]];
		t0[631:624] <= s_box[in[432 +: 8]];
		t0[623:616] <= s_box[in[296 +: 8]];
		t0[615:608] <= s_box[in[928 +: 8]];
		t0[607:600] <= s_box[in[600 +: 8]];
		t0[599:592] <= s_box[in[464 +: 8]];
		t0[591:584] <= s_box[in[328 +: 8]];
		t0[583:576] <= s_box[~in[192 +: 8] ^ { 4'h3, round } ];
		t0[575:568] <= s_box[in[504 +: 8]];
		t0[567:560] <= s_box[in[368 +: 8]];
		t0[559:552] <= s_box[in[232 +: 8]];
		t0[551:544] <= s_box[in[864 +: 8]];
		t0[543:536] <= s_box[in[536 +: 8]];
		t0[535:528] <= s_box[in[400 +: 8]];
		t0[527:520] <= s_box[in[264 +: 8]];
		t0[519:512] <= s_box[~in[128 +: 8] ^ { 4'h2, round } ];
		t0[511:504] <= s_box[in[440 +: 8]];
		t0[503:496] <= s_box[in[304 +: 8]];
		t0[495:488] <= s_box[in[168 +: 8]];
		t0[487:480] <= s_box[in[800 +: 8]];
		t0[479:472] <= s_box[in[472 +: 8]];
		t0[471:464] <= s_box[in[336 +: 8]];
		t0[463:456] <= s_box[in[200 +: 8]];
		t0[455:448] <= s_box[~in[64 +: 8] ^ { 4'h1, round } ];
		t0[447:440] <= s_box[in[376 +: 8]];
		t0[439:432] <= s_box[in[240 +: 8]];
		t0[431:424] <= s_box[in[104 +: 8]];
		t0[423:416] <= s_box[in[736 +: 8]];
		t0[415:408] <= s_box[in[408 +: 8]];
		t0[407:400] <= s_box[in[272 +: 8]];
		t0[399:392] <= s_box[in[136 +: 8]];
		t0[391:384] <= s_box[~in[0 +: 8] ^ { 4'h0, round } ];
		t0[383:376] <= s_box[in[312 +: 8]];
		t0[375:368] <= s_box[in[176 +: 8]];
		t0[367:360] <= s_box[in[40 +: 8]];
		t0[359:352] <= s_box[in[672 +: 8]];
		t0[351:344] <= s_box[in[344 +: 8]];
		t0[343:336] <= s_box[in[208 +: 8]];
		t0[335:328] <= s_box[in[72 +: 8]];
		t0[327:320] <= s_box[~in[960 +: 8] ^ { 4'hF, round } ];
		t0[319:312] <= s_box[in[248 +: 8]];
		t0[311:304] <= s_box[in[112 +: 8]];
		t0[303:296] <= s_box[in[1000 +: 8]];
		t0[295:288] <= s_box[in[608 +: 8]];
		t0[287:280] <= s_box[in[280 +: 8]];
		t0[279:272] <= s_box[in[144 +: 8]];
		t0[271:264] <= s_box[in[8 +: 8]];
		t0[263:256] <= s_box[~in[896 +: 8] ^ { 4'hE, round } ];
		t0[255:248] <= s_box[in[184 +: 8]];
		t0[247:240] <= s_box[in[48 +: 8]];
		t0[239:232] <= s_box[in[936 +: 8]];
		t0[231:224] <= s_box[in[544 +: 8]];
		t0[223:216] <= s_box[in[216 +: 8]];
		t0[215:208] <= s_box[in[80 +: 8]];
		t0[207:200] <= s_box[in[968 +: 8]];
		t0[199:192] <= s_box[~in[832 +: 8] ^ { 4'hD, round } ];
		t0[191:184] <= s_box[in[120 +: 8]];
		t0[183:176] <= s_box[in[1008 +: 8]];
		t0[175:168] <= s_box[in[872 +: 8]];
		t0[167:160] <= s_box[in[480 +: 8]];
		t0[159:152] <= s_box[in[152 +: 8]];
		t0[151:144] <= s_box[in[16 +: 8]];
		t0[143:136] <= s_box[in[904 +: 8]];
		t0[135:128] <= s_box[~in[768 +: 8] ^ { 4'hC, round } ];
		t0[127:120] <= s_box[in[56 +: 8]];
		t0[119:112] <= s_box[in[944 +: 8]];
		t0[111:104] <= s_box[in[808 +: 8]];
		t0[103:96] <= s_box[in[416 +: 8]];
		t0[95:88] <= s_box[in[88 +: 8]];
		t0[87:80] <= s_box[in[976 +: 8]];
		t0[79:72] <= s_box[in[840 +: 8]];
		t0[71:64] <= s_box[~in[704 +: 8] ^ { 4'hB, round } ];
		t0[63:56] <= s_box[in[1016 +: 8]];
		t0[55:48] <= s_box[in[880 +: 8]];
		t0[47:40] <= s_box[in[744 +: 8]];
		t0[39:32] <= s_box[in[352 +: 8]];
		t0[31:24] <= s_box[in[24 +: 8]];
		t0[23:16] <= s_box[in[912 +: 8]];
		t0[15:8] <= s_box[in[776 +: 8]];
		t0[7:0] <= s_box[~in[640 +: 8] ^ { 4'hA, round } ];

	end

	always @ (posedge clk) begin
	
		t1 <= t0;

	end
	
	mix_bytes mb00 (clk, t1, out);

endmodule
