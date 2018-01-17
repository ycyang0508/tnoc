module noc_output_block_dummy
  import  noc_config_pkg::*;
#(
  parameter noc_config  CONFIG  = NOC_DEFAULT_CONFIG
)(
  noc_flit_if.target              flit_in_if_xp,
  noc_flit_if.target              flit_in_if_xm,
  noc_flit_if.target              flit_in_if_yp,
  noc_flit_if.target              flit_in_if_ym,
  noc_flit_if.target              flit_in_if_l,
  noc_flit_if.initiator           flit_out_if,
  noc_port_control_if.arbitrator  port_control_if_xp,
  noc_port_control_if.arbitrator  port_control_if_xm,
  noc_port_control_if.arbitrator  port_control_if_yp,
  noc_port_control_if.arbitrator  port_control_if_ym,
  noc_port_control_if.arbitrator  port_control_if_l
);
  noc_flit_if #(CONFIG)         flit_in_if[5]();
  noc_port_control_if #(CONFIG) port_control_if[5]();

  noc_flit_if_renamer u_flit_if_renamer_0 (flit_in_if_xp, flit_in_if[0]);
  noc_flit_if_renamer u_flit_if_renamer_1 (flit_in_if_xm, flit_in_if[1]);
  noc_flit_if_renamer u_flit_if_renamer_2 (flit_in_if_yp, flit_in_if[2]);
  noc_flit_if_renamer u_flit_if_renamer_3 (flit_in_if_ym, flit_in_if[3]);
  noc_flit_if_renamer u_flit_if_renamer_4 (flit_in_if_l , flit_in_if[4]);

  noc_port_control_if_renamer u_port_control_if_renamer_0 (port_control_if_xp, port_control_if[0]);
  noc_port_control_if_renamer u_port_control_if_renamer_1 (port_control_if_xm, port_control_if[1]);
  noc_port_control_if_renamer u_port_control_if_renamer_2 (port_control_if_yp, port_control_if[2]);
  noc_port_control_if_renamer u_port_control_if_renamer_3 (port_control_if_ym, port_control_if[3]);
  noc_port_control_if_renamer u_port_control_if_renamer_4 (port_control_if_l , port_control_if[4]);

  assign  flit_out_if.valid = '0;
  assign  flit_out_if.flit  = '0;

  generate for (genvar i = 0;i < 5;++i) begin
    assign  flit_in_if[i].ready         = '0;
    assign  flit_in_if[i].vc_available  = '0;

    assign  port_control_if[i].grant  = '0;
  end endgenerate
endmodule
