class AHB_driver extends uvm_driver #(AHB_xtn);

    `uvm_component_utils (AHB_driver)

    AHB_agent_config cfg;
    virtual AHB_intf.DRV_MP vif;

    extern function new(string name = "AHB_driver",  uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task drv2dut(AHB_xtn xtn);

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function AHB_driver::new(string name = "AHB_driver",  uvm_component parent);
        super.new(name,parent);
    endfunction


    /////////////////////////////////////////////////////////////////////////////////////
    function void AHB_driver::build_phase(uvm_phase phase);
        if (!uvm_config_db #(AHB_agent_config)::get(this, "", "AHB_agent_config",cfg))
            `uvm_fatal("CONFIG","Getting config database failed")
        super.build_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void AHB_driver::connect_phase(uvm_phase phase);
        vif = cfg.vif;
        super.connect_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task AHB_driver::run_phase(uvm_phase phase);
        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b0; 
        repeat(2) 
            @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b1;
        forever begin
            seq_item_port.get_next_item(req);
            drv2dut(req);
            seq_item_port.item_done();
        end
    endtask

    /////////////////////////////////////////////////////////////////////////////////////

    task AHB_driver::drv2dut(AHB_xtn xtn);
        //xtn.print();
        vif.ahb_drv_cb.Hwrite <= xtn.Hwrite;
        vif.ahb_drv_cb.Htrans <= xtn.Htrans;
        vif.ahb_drv_cb.Hburst <= xtn.Hburst;
        vif.ahb_drv_cb.Hsize  <= xtn.Hsize;
        vif.ahb_drv_cb.Haddr  <= xtn.Haddr;
        vif.ahb_drv_cb.Hreadyin <= 1'b1;

        @(vif.ahb_drv_cb);
        wait(vif.ahb_drv_cb.Hreadyout)
        vif.ahb_drv_cb.Hwdata <= xtn.Hwdata;
         
    endtask

///****************************************************************************************************///
