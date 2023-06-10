`timescale 1ns/10ps
`define CLK_period 10.0               // Modify CLK period.
`define TIMEOUT 10000                 // Modify END cycle.

// pattern count definition
`define BIT_REF     7
`define BIT_QUERY   6
`define COUNT_REF   64
`define COUNT_QUERY 48
`define BIT_SCORE   8

// data path definition
`ifdef tb1
  `define PATS  "./dat/ref1.dat"
  `define PATT  "./dat/query1.dat"
  `define EXP   "./dat/golden1.dat"
  `define BSW   "./dat/bsw1.dat"
  `define SW   "./dat/sw1.dat"
`elsif tb2
  `define PATS  "./dat/ref2.dat"
  `define PATT  "./dat/query2.dat"
  `define EXP   "./dat/golden2.dat"
  `define BSW   "./dat/bsw2.dat"
  `define SW   "./dat/sw2.dat"
`elsif tb3   //// your test pattern
  `define PATS  "./dat/ref3.dat"
  `define PATT  "./dat/query3.dat"
  `define EXP   "./dat/golden3.dat"
  `define BSW   "./dat/bsw3.dat"
  `define SW   "./dat/sw3.dat"
`elsif tb4   //// your test pattern
  `define PATS  "./dat/ref4.dat"
  `define PATT  "./dat/query4.dat"
  `define EXP   "./dat/golden4.dat"
  `define BSW   "./dat/bsw4.dat"
  `define SW   "./dat/sw4.dat"
`elsif tb5   //// your test pattern
  `define PATS  "./dat/ref5.dat"
  `define PATT  "./dat/query5.dat"
  `define EXP   "./dat/golden5.dat"
  `define BSW   "./dat/bsw5.dat"
  `define SW   "./dat/sw5.dat"
`elsif tb6   //// your test pattern
  `define PATS  "./dat/ref6.dat"
  `define PATT  "./dat/query6.dat"
  `define EXP   "./dat/golden6.dat"
  `define BSW   "./dat/bsw6.dat"
  `define SW   "./dat/sw6.dat"
`elsif tb7   //// your test pattern
  `define PATS  "./dat/ref7.dat"
  `define PATT  "./dat/query7.dat"
  `define EXP   "./dat/golden7.dat"
  `define BSW   "./dat/bsw7.dat"
  `define SW   "./dat/sw7.dat"
`elsif tb8   //// your test pattern
  `define PATS  "./dat/ref8.dat"
  `define PATT  "./dat/query8.dat"
  `define EXP   "./dat/golden8.dat"
  `define BSW   "./dat/bsw8.dat"
  `define SW   "./dat/sw8.dat"
`elsif tb9   //// your test pattern
  `define PATS  "./dat/ref9.dat"
  `define PATT  "./dat/query9.dat"
  `define EXP   "./dat/golden9.dat"
  `define BSW   "./dat/bsw9.dat"
  `define SW   "./dat/sw9.dat"
`elsif tb10   //// your test pattern
  `define PATS  "./dat/ref10.dat"
  `define PATT  "./dat/query10.dat"
  `define EXP   "./dat/golden10.dat"
  `define BSW   "./dat/bsw10.dat"
  `define SW   "./dat/sw10.dat"
`endif

module tb;
  reg CLK;
  reg reset;
  reg [1:0] ref_mem [0:(`COUNT_REF)-1];
  reg [1:0] query_mem [0:(`COUNT_QUERY)-1];
  reg [11:0] exp_mem [0:2];
  reg [11:0] bsw_mem [0:2];
  reg [11:0] sw_mem [0:2];
  
  
  reg valid;
  reg [1:0] data_ref;
  reg [1:0] data_query;
  integer i;
  integer cycle;


  wire finish;
  wire [(`BIT_SCORE)-1:0]   max;
  wire [(`BIT_REF)-1:0]     pos_ref;
  wire [(`BIT_QUERY)-1:0]   pos_query;

  reg flag; 

  initial begin
    `ifdef SDFSYN
      $sdf_annotate("SW_syn.sdf", u_sw);
    `endif
    `ifdef SDFAPR
      $sdf_annotate("SW_APR.sdf", u_sw);
    `endif
    `ifdef FSDB
      $fsdbDumpfile("SW.fsdb");
      $fsdbDumpvars();
      $fsdbDumpMDA;
    `endif
    `ifdef VCD
      $dumpfile("SW.vcd");
      $dumpvars();
    `endif
  end

  SW u_sw(.clk(CLK), .reset(reset), .valid(valid), .data_ref(data_ref), .data_query(data_query), .finish(finish), .max(max), .pos_ref(pos_ref), .pos_query(pos_query) ); 


  initial $readmemh(`PATS, ref_mem);
  initial $readmemh(`PATT, query_mem);
  initial $readmemh(`EXP, exp_mem);
  initial $readmemh(`BSW, bsw_mem);
  initial $readmemh(`SW, sw_mem);
  initial $display("%s, %s and %s were used for this simulation.", `PATS, `PATT,  `EXP);  

  initial CLK = 1'b0;

  always begin #(`CLK_period/2) CLK = ~CLK; end

  initial begin
    cycle = 0;
    #0 reset = 1'b0;
    #(`CLK_period) reset = 1'b1;
    #(`CLK_period*2) reset = 1'b0;
  end

  initial begin
    data_ref = 0;
    data_query = 0;
    #0 valid = 1'b0;
    i = 0;
    #(`CLK_period*5);
    @(negedge CLK) valid = 1'b1;
    data_ref = ref_mem[i];
    data_query = query_mem[i];
    for (i=1;i<`COUNT_QUERY;i=i+1) begin
      @(negedge CLK) begin 
        data_ref = ref_mem[i];
        data_query = query_mem[i];
      end
    end
    for (i=`COUNT_QUERY;i<`COUNT_REF;i=i+1) begin
      @(negedge CLK) begin 
        data_ref = ref_mem[i];
        data_query = 0;
      end
      //@(negedge CLK) data_query = query_mem[i];
    end
    @(negedge CLK) valid = 1'b0;
        data_ref = 2'b0;
        data_query = 2'b0;
  end


  always@(negedge CLK) begin
    if (reset) begin
      flag <= 1'b0;
    end 
    else begin

      if(finish == 1'b1) begin
        if (exp_mem[0][(`BIT_SCORE)-1:0] === max && exp_mem[1][(`BIT_REF)-1:0] === pos_ref && exp_mem[2][(`BIT_QUERY)-1:0] === pos_query) begin    
          flag <= 1'b1;
          $display("\n");
          $display("====================== The test result is ..... PASS ========================");
          $display("\n");
          $display("        *************************************************            ");
          $display("        **                                             **      /|____|\\");
          $display("        **             Congratulations !!              **    ((´-___- `))");
          $display("        **                                             **   ///        \\\\\\");
          $display("        **  All data have been generated successfully! **  /||          ||\\");
          $display("        **                                             **  w|\\ m      m /|w");
          $display("        *************************************************    \\(o)____(o)/");
          $display("\n");
          $display("============================================================================");
		  $display("   sw answer:   max=%d, pos_ref=%d, pos_query= %d\n", sw_mem[0][(`BIT_SCORE)-1:0], sw_mem[1][(`BIT_REF)-1:0] , sw_mem[2][(`BIT_QUERY)-1:0]);
		  $display("   bsw answer:  max=%d, pos_ref=%d, pos_query= %d\n", bsw_mem[0][(`BIT_SCORE)-1:0], bsw_mem[1][(`BIT_REF)-1:0] , bsw_mem[2][(`BIT_QUERY)-1:0]);
		  $display("   rbsw answer: max=%d, pos_ref=%d, pos_query= %d\n", exp_mem[0][(`BIT_SCORE)-1:0], exp_mem[1][(`BIT_REF)-1:0] , exp_mem[2][(`BIT_QUERY)-1:0]);
          $display("   total cycle: %d", cycle);
          $finish;
        end else begin
          $display("\n");
          $display("-------------- The test result is ..... FAIL --------------\n");
          $display("------------------ Simulation stop here. ------------------");
          $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
          $display("   correct answer:  max=%d, pos_ref=%d, pos_query= %d\n", exp_mem[0][(`BIT_SCORE)-1:0], exp_mem[1][(`BIT_REF)-1:0] , exp_mem[2][(`BIT_QUERY)-1:0]);
          $display("   but your answer: max=%d, pos_ref=%d, pos_query= %d\n", max, pos_ref, pos_query);
          $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		  $display("   sw answer:   max=%d, pos_ref=%d, pos_query= %d\n", sw_mem[0][(`BIT_SCORE)-1:0], sw_mem[1][(`BIT_REF)-1:0] , sw_mem[2][(`BIT_QUERY)-1:0]);
		  $display("   bsw answer:  max=%d, pos_ref=%d, pos_query= %d\n", bsw_mem[0][(`BIT_SCORE)-1:0], bsw_mem[1][(`BIT_REF)-1:0] , bsw_mem[2][(`BIT_QUERY)-1:0]);
		  $display("   rbsw answer: max=%d, pos_ref=%d, pos_query= %d\n", exp_mem[0][(`BIT_SCORE)-1:0], exp_mem[1][(`BIT_REF)-1:0] , exp_mem[2][(`BIT_QUERY)-1:0]);
          $display("   total cycle: %d", cycle);
          $finish;
        end
      end
    end
  end

  always @(negedge CLK) begin
      cycle=cycle+1;
      if (cycle > `TIMEOUT*`CLK_period) begin
          $display("**************************************************************************");
          $display("**  Failed waiting Valid signal, Simulation STOP at cycle %d\t**",cycle);
          $display("**  If needed, You can increase End_CYCLE value in tb.v\t\t\t**");
          $display("**************************************************************************");
          $finish;
      end
  end


endmodule

