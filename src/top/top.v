`timescale 1 ps / 1 ps

module top(
	input clock_100_0
);

  pr_loopback inst_rp_0 (
    .clock (clk_100_0),
    .in (to_pr_0),
    .out (from_pr_0)
  );

  wire lp_1;
  pr_loopback inst_rp_1 (
    .clock (clk_100_0),
    .in (lp_1),
    .out (lp_1)
  );

  wire lp_2;
  pr_loopback inst_rp_2 (
    .clock (clk_100_0),
    .in (lp_2),
    .out (lp_2)
  );

  wire lp_3;
  pr_loopback inst_rp_3 (
    .clock (clk_100_0),
    .in (lp_3),
    .out (lp_3)
  );

endmodule

/*
 * Black-box definition
 */
module pr_loopback(
    input clock,
    input [31:0] in,
    output reg [31:0] out
    );
endmodule
