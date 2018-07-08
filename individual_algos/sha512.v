module sha512 (
	input clk,
	input [1023:0] data,
	input [511:0] state,
	output reg [511:0] hash
);

	wire [1023:0] w0, w1, w2, w3, w4, w5, w6, w7;
	wire [1023:0] w8, w9, w10,w11,w12,w13,w14,w15;
	wire [1023:0] w16,w17,w18,w19,w20,w21,w22,w23;
	wire [1023:0] w24,w25,w26,w27,w28,w29,w30,w31;
	wire [1023:0] w32,w33,w34,w35,w36,w37,w38,w39;
	wire [1023:0] w40,w41,w42,w43,w44,w45,w46,w47;
	wire [1023:0] w48,w49,w50,w51,w52,w53,w54,w55;
	wire [1023:0] w56,w57,w58,w59,w60,w61,w62,w63;
	wire [1023:0] w64,w65,w66,w67,w68,w69,w70,w71;
	wire [1023:0] w72,w73,w74,w75,w76,w77,w78,w79,w80;
	
	wire [511:0] h0, h1, h2, h3, h4, h5, h6, h7;
	wire [511:0] h8, h9, h10,h11,h12,h13,h14,h15;
	wire [511:0] h16,h17,h18,h19,h20,h21,h22,h23;
	wire [511:0] h24,h25,h26,h27,h28,h29,h30,h31;
	wire [511:0] h32,h33,h34,h35,h36,h37,h38,h39;
	wire [511:0] h40,h41,h42,h43,h44,h45,h46,h47;
	wire [511:0] h48,h49,h50,h51,h52,h53,h54,h55;
	wire [511:0] h56,h57,h58,h59,h60,h61,h62,h63;
	wire [511:0] h64,h65,h66,h67,h68,h69,h70,h71;
	wire [511:0] h72,h73,h74,h75,h76,h77,h78,h79,h80;
	
	sha512_digest digest0  ( clk, data, state,  64'h428a2f98d728ae22, w1, h1 );
	sha512_digest digest1  ( clk, w1,  h1,  64'h7137449123ef65cd, w2, h2 );
	sha512_digest digest2  ( clk, w2,  h2,  64'hb5c0fbcfec4d3b2f, w3, h3 );
	sha512_digest digest3  ( clk, w3,  h3,  64'he9b5dba58189dbbc, w4, h4 );
	sha512_digest digest4  ( clk, w4,  h4,  64'h3956c25bf348b538, w5, h5 );
	sha512_digest digest5  ( clk, w5,  h5,  64'h59f111f1b605d019, w6, h6 );
	sha512_digest digest6  ( clk, w6,  h6,  64'h923f82a4af194f9b, w7, h7 );
	sha512_digest digest7  ( clk, w7,  h7,  64'hab1c5ed5da6d8118, w8, h8 );
	sha512_digest digest8  ( clk, w8,  h8,  64'hd807aa98a3030242, w9, h9 );
	sha512_digest digest9  ( clk, w9,  h9,  64'h12835b0145706fbe, w10, h10 );
	sha512_digest digest10 ( clk, w10, h10, 64'h243185be4ee4b28c, w11, h11 );
	sha512_digest digest11 ( clk, w11, h11, 64'h550c7dc3d5ffb4e2, w12, h12 );
	sha512_digest digest12 ( clk, w12, h12, 64'h72be5d74f27b896f, w13, h13 );
	sha512_digest digest13 ( clk, w13, h13, 64'h80deb1fe3b1696b1, w14, h14 );
	sha512_digest digest14 ( clk, w14, h14, 64'h9bdc06a725c71235, w15, h15 );
	sha512_digest digest15 ( clk, w15, h15, 64'hc19bf174cf692694, w16, h16 );
	sha512_digest digest16 ( clk, w16, h16, 64'he49b69c19ef14ad2, w17, h17 );
	sha512_digest digest17 ( clk, w17, h17, 64'hefbe4786384f25e3, w18, h18 );
	sha512_digest digest18 ( clk, w18, h18, 64'h0fc19dc68b8cd5b5, w19, h19 );
	sha512_digest digest19 ( clk, w19, h19, 64'h240ca1cc77ac9c65, w20, h20 );
	sha512_digest digest20 ( clk, w20, h20, 64'h2de92c6f592b0275, w21, h21 );
	sha512_digest digest21 ( clk, w21, h21, 64'h4a7484aa6ea6e483, w22, h22 );
	sha512_digest digest22 ( clk, w22, h22, 64'h5cb0a9dcbd41fbd4, w23, h23 );
	sha512_digest digest23 ( clk, w23, h23, 64'h76f988da831153b5, w24, h24 );
	sha512_digest digest24 ( clk, w24, h24, 64'h983e5152ee66dfab, w25, h25 );
	sha512_digest digest25 ( clk, w25, h25, 64'ha831c66d2db43210, w26, h26 );
	sha512_digest digest26 ( clk, w26, h26, 64'hb00327c898fb213f, w27, h27 );
	sha512_digest digest27 ( clk, w27, h27, 64'hbf597fc7beef0ee4, w28, h28 );
	sha512_digest digest28 ( clk, w28, h28, 64'hc6e00bf33da88fc2, w29, h29 );
	sha512_digest digest29 ( clk, w29, h29, 64'hd5a79147930aa725, w30, h30 );
	sha512_digest digest30 ( clk, w30, h30, 64'h06ca6351e003826f, w31, h31 );
	sha512_digest digest31 ( clk, w31, h31, 64'h142929670a0e6e70, w32, h32 );
	sha512_digest digest32 ( clk, w32, h32, 64'h27b70a8546d22ffc, w33, h33 );
	sha512_digest digest33 ( clk, w33, h33, 64'h2e1b21385c26c926, w34, h34 );
	sha512_digest digest34 ( clk, w34, h34, 64'h4d2c6dfc5ac42aed, w35, h35 );
	sha512_digest digest35 ( clk, w35, h35, 64'h53380d139d95b3df, w36, h36 );
	sha512_digest digest36 ( clk, w36, h36, 64'h650a73548baf63de, w37, h37 );
	sha512_digest digest37 ( clk, w37, h37, 64'h766a0abb3c77b2a8, w38, h38 );
	sha512_digest digest38 ( clk, w38, h38, 64'h81c2c92e47edaee6, w39, h39 );
	sha512_digest digest39 ( clk, w39, h39, 64'h92722c851482353b, w40, h40 );
	sha512_digest digest40 ( clk, w40, h40, 64'ha2bfe8a14cf10364, w41, h41 );
	sha512_digest digest41 ( clk, w41, h41, 64'ha81a664bbc423001, w42, h42 );
	sha512_digest digest42 ( clk, w42, h42, 64'hc24b8b70d0f89791, w43, h43 );
	sha512_digest digest43 ( clk, w43, h43, 64'hc76c51a30654be30, w44, h44 );
	sha512_digest digest44 ( clk, w44, h44, 64'hd192e819d6ef5218, w45, h45 );
	sha512_digest digest45 ( clk, w45, h45, 64'hd69906245565a910, w46, h46 );
	sha512_digest digest46 ( clk, w46, h46, 64'hf40e35855771202a, w47, h47 );
	sha512_digest digest47 ( clk, w47, h47, 64'h106aa07032bbd1b8, w48, h48 );
	sha512_digest digest48 ( clk, w48, h48, 64'h19a4c116b8d2d0c8, w49, h49 );
	sha512_digest digest49 ( clk, w49, h49, 64'h1e376c085141ab53, w50, h50 );
	sha512_digest digest50 ( clk, w50, h50, 64'h2748774cdf8eeb99, w51, h51 );
	sha512_digest digest51 ( clk, w51, h51, 64'h34b0bcb5e19b48a8, w52, h52 );
	sha512_digest digest52 ( clk, w52, h52, 64'h391c0cb3c5c95a63, w53, h53 );
	sha512_digest digest53 ( clk, w53, h53, 64'h4ed8aa4ae3418acb, w54, h54 );
	sha512_digest digest54 ( clk, w54, h54, 64'h5b9cca4f7763e373, w55, h55 );
	sha512_digest digest55 ( clk, w55, h55, 64'h682e6ff3d6b2b8a3, w56, h56 );
	sha512_digest digest56 ( clk, w56, h56, 64'h748f82ee5defb2fc, w57, h57 );
	sha512_digest digest57 ( clk, w57, h57, 64'h78a5636f43172f60, w58, h58 );
	sha512_digest digest58 ( clk, w58, h58, 64'h84c87814a1f0ab72, w59, h59 );
	sha512_digest digest59 ( clk, w59, h59, 64'h8cc702081a6439ec, w60, h60 );
	sha512_digest digest60 ( clk, w60, h60, 64'h90befffa23631e28, w61, h61 );
	sha512_digest digest61 ( clk, w61, h61, 64'ha4506cebde82bde9, w62, h62 );
	sha512_digest digest62 ( clk, w62, h62, 64'hbef9a3f7b2c67915, w63, h63 );
	sha512_digest digest63 ( clk, w63, h63, 64'hc67178f2e372532b, w64, h64 );
	sha512_digest digest64 ( clk, w64, h64, 64'hca273eceea26619c, w65, h65 );
	sha512_digest digest65 ( clk, w65, h65, 64'hd186b8c721c0c207, w66, h66 );
	sha512_digest digest66 ( clk, w66, h66, 64'heada7dd6cde0eb1e, w67, h67 );
	sha512_digest digest67 ( clk, w67, h67, 64'hf57d4f7fee6ed178, w68, h68 );
	sha512_digest digest68 ( clk, w68, h68, 64'h06f067aa72176fba, w69, h69 );
	sha512_digest digest69 ( clk, w69, h69, 64'h0a637dc5a2c898a6, w70, h70 );
	sha512_digest digest70 ( clk, w70, h70, 64'h113f9804bef90dae, w71, h71 );
	sha512_digest digest71 ( clk, w71, h71, 64'h1b710b35131c471b, w72, h72 );
	sha512_digest digest72 ( clk, w72, h72, 64'h28db77f523047d84, w73, h73 );
	sha512_digest digest73 ( clk, w73, h73, 64'h32caab7b40c72493, w74, h74 );
	sha512_digest digest74 ( clk, w74, h74, 64'h3c9ebe0a15c9bebc, w75, h75 );
	sha512_digest digest75 ( clk, w75, h75, 64'h431d67c49c100d4c, w76, h76 );
	sha512_digest digest76 ( clk, w76, h76, 64'h4cc5d4becb3e42b6, w77, h77 );
	sha512_digest digest77 ( clk, w77, h77, 64'h597f299cfc657e2a, w78, h78 );
	sha512_digest digest78 ( clk, w78, h78, 64'h5fcb6fab3ad6faec, w79, h79 );
	sha512_digest digest79 ( clk, w79, h79, 64'h6c44198c4a475817, w80, h80 );

	always @ (posedge clk) begin

		hash[511:448] <= h80[511:448] + state[511:448];
		hash[447:384] <= h80[447:384] + state[447:384];
		hash[383:320] <= h80[383:320] + state[383:320];
		hash[319:256] <= h80[319:256] + state[319:256];
		hash[255:192] <= h80[255:192] + state[255:192];
		hash[191:128] <= h80[191:128] + state[191:128];
		hash[127: 64] <= h80[127: 64] + state[127: 64];
		hash[ 63:  0] <= h80[ 63:  0] + state[ 63:  0];

	end

endmodule

module sha512_digest (clk, rx_w, rx_state, k, tx_w, tx_state);

	input clk;
	input [1023:0] rx_w;
	input [511:0] rx_state;
	input [63:0] k;

	output reg [1023:0] tx_w;
	output reg [511:0] tx_state;


	wire [63:0] e0_w, e1_w, ch_w, maj_w, s0_w, s1_w;


	sha512_S0	e0_blk	(rx_state[ 63:  0], e0_w);
	sha512_S1	e1_blk	(rx_state[319:256], e1_w);
	sha512_ch	ch_blk	(rx_state[319:256], rx_state[383:320], rx_state[447:384], ch_w);
	sha512_maj	maj_blk	(rx_state[ 63:  0], rx_state[127: 64], rx_state[191:128], maj_w);
	sha512_s0	s0_blk	(rx_w[127:64], s0_w);
	sha512_s1	s1_blk	(rx_w[959:896], s1_w);

	wire [63:0] t1 = rx_state[511:448] + e1_w + ch_w + rx_w[63:0] + k;
	wire [63:0] t2 = e0_w + maj_w;
	wire [63:0] new_w = s1_w + rx_w[639:576] + s0_w + rx_w[63:0];
	

	always @ (posedge clk)
	begin
		tx_w[1023:960] <= new_w;
		tx_w[959:0] <= rx_w[1023:64];

		tx_state[511:448] <= rx_state[447:384];
		tx_state[447:384] <= rx_state[383:320];
		tx_state[383:320] <= rx_state[319:256];
		tx_state[319:256] <= rx_state[255:192] + t1;
		tx_state[255:192] <= rx_state[191:128];
		tx_state[191:128] <= rx_state[127: 64];
		tx_state[127: 64] <= rx_state[ 63:  0];
		tx_state[ 63:  0] <= t1 + t2;
	end

endmodule

module sha512_S0 (
    input wire [63:0] x,
    output wire [63:0] S0
    );

assign S0 = ({x[27:0], x[63:28]} ^ {x[33:0], x[63:34]} ^ {x[38:0], x[63:39]});

endmodule

module sha512_S1 (
    input wire [63:0] x,
    output wire [63:0] S1
    );

assign S1 = ({x[13:0], x[63:14]} ^ {x[17:0], x[63:18]} ^ {x[40:0], x[63:41]});

endmodule

module sha512_s0 (
    input wire [63:0] x,
    output wire [63:0] s0
    );

assign s0 = ({x[0:0], x[63:1]} ^ {x[7:0], x[63:8]} ^ (x >> 7));

endmodule

module sha512_s1 (
    input wire [63:0] x,
    output wire [63:0] s1
    );

assign s1 = ({x[18:0], x[63:19]} ^ {x[60:0], x[63:61]} ^ (x >> 6));

endmodule

module sha512_ch (x, y, z, o);

	input [63:0] x, y, z;
	output [63:0] o;

	assign o = z ^ (x & (y ^ z));

endmodule

module sha512_maj (x, y, z, o);

	input [63:0] x, y, z;
	output [63:0] o;

	assign o = (x & y) | (z & (x | y));

endmodule
