`ifndef NOC_BFM_PACKET_DRIVER_SVH
`define NOC_BFM_PACKET_DRIVER_SVH

typedef tue_driver #(
  .CONFIGURATION  (noc_bfm_configuration  ),
  .STATUS         (noc_bfm_status         ),
  .REQ            (noc_bfm_packet_item    )
) noc_bfm_packet_driver_base;

class noc_bfm_packet_driver extends noc_bfm_component_base #(
  noc_bfm_packet_driver_base
);
  noc_bfm_flit_vif    vif;
  noc_bfm_packet_item packet_item;
  noc_bfm_flit_item   flit_items[$];

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    vif = configuration.tx_vif;
  endfunction

  task run_phase(uvm_phase phase);
    forever @(vif.master_cb, negedge vif.rst_n) begin
      if (!vif.rst_n) begin
        do_reset();
      end
      else begin
        if ((vif.monitor_cb.valid & vif.monitor_cb.ready) != '0) begin
          finish_flit();
        end

        if ((packet_item == null) && seq_item_port.has_do_available()) begin
          get_packet_item();
        end

        if (packet_item != null) begin
          drive_flit();
        end
      end
    end
  endtask

  task do_reset();
    vif.valid = '0;
    vif.flit  = '0;
    if (packet_item != null) begin
      finish_packet_item();
    end
  endtask

  task get_packet_item();
    seq_item_port.get_next_item(packet_item);
    void'(begin_tr(packet_item));
    flit_items.delete();
    packet_item.pack_flit_items(flit_items);
  endtask

  task drive_flit();
    if (flit_items[0].begin_event.is_off) begin
      void'(begin_child_tr(flit_items[0], packet_item.tr_handle));
      vif.master_cb.valid[packet_item.virtual_channel]  <= '1;
      vif.master_cb.flit                                <= flit_items[0].get_flit();
    end
  endtask

  task finish_flit();
    vif.master_cb.valid <= '0;
    vif.master_cb.flit  <= '0;

    end_tr(flit_items[0]);
    void'(flit_items.pop_front());

    if (flit_items.size == 0) begin
      finish_packet_item();
    end
  endtask

  task finish_packet_item();
    end_tr(packet_item);
    packet_item = null;
    seq_item_port.item_done();
    uvm_wait_for_nba_region();
  endtask

  `tue_component_default_constructor(noc_bfm_packet_driver)
  `uvm_component_utils(noc_bfm_packet_driver)
endclass
`endif
