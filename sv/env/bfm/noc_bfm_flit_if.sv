`ifndef NOC_BFM_FLIT_IF_SV
`define NOC_BFM_FLIT_IF_SV
interface noc_bfm_flit_if (
  input logic clk,
  input logic rst_n
);
  `include  "noc_bfm_macro.svh"

  import  noc_bfm_types_pkg::noc_bfm_flit;

  localparam  int CHANNELS  = `NOC_BFM_MAX_VIRTUAL_CHANNELS;

  bit [CHANNELS-1:0]  valid;
  bit [CHANNELS-1:0]  ready;
  noc_bfm_flit        flit;

  clocking master_cb @(posedge clk);
    output  valid;
    input   ready;
    output  flit;
  endclocking

  clocking slave_cb @(posedge clk);
    input   valid;
    output  ready;
    input   flit;
  endclocking

  clocking monitor_cb @(posedge clk);
    input valid;
    input ready;
    input flit;
  endclocking
endinterface
`endif
