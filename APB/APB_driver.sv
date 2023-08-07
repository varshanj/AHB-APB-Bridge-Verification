class APB_driver extends uvm_driver #(APB_xtn);

    `uvm_component_utils (APB_driver)

    APB_agent_config cfg;
    virtual APB_intf.APB_DRV_MP ivif;

    extern function new(string name = "APB_driver",  uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task drv2dut(APB_xtn xtn);

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function APB_driver::new(string name = "APB_driver",  uvm_component parent);
        super.new(name,parent);
    endfunction


    /////////////////////////////////////////////////////////////////////////////////////
    function void APB_driver::build_phase(uvm_phase phase);
        if (!uvm_config_db #(APB_agent_config)::get(this, "", "APB_agent_config",cfg))
            `uvm_fatal("CONFIG","Getting config database failed")
        super.build_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void APB_driver::connect_phase(uvm_phase phase);
        ivif = cfg.vif;
        super.connect_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task APB_driver::run_phase(uvm_phase phase);
        req = APB_xtn::type_id::create("req",this);
        forever begin
            seq_item_port.get_next_item(req);
            drv2dut(req);
            seq_item_port.item_done();
        end
    endtask

    /////////////////////////////////////////////////////////////////////////////////////

    task APB_driver::drv2dut(APB_xtn xtn);
        wait(ivif.apb_drv_cb.Pselx != 0);
            if(ivif.apb_drv_cb.Pwrite == 0)
                ivif.apb_drv_cb.Prdata <= {$random};

            //xtn.print();
        repeat(2) @(ivif.apb_drv_cb);    
        wait(ivif.apb_drv_cb.Penable);
    endtask


///****************************************************************************************************///
