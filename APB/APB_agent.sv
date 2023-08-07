class APB_agent extends uvm_agent;

    `uvm_component_utils (APB_agent)

    APB_agent_config apb_cfg;
    APB_driver apb_drv;
    APB_monitor apb_mon;
    APB_sequencer apb_seqr;

    extern function new(string name = "APB_agent",  uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function APB_agent::new(string name = "APB_agent",uvm_component parent);
        super.new(name,parent);
    endfunction: new

    /////////////////////////////////////////////////////////////////////////////////////

    function void APB_agent::build_phase(uvm_phase phase);
        if(!uvm_config_db #(APB_agent_config)::get(this,"","APB_agent_config",apb_cfg))
            `uvm_fatal("CONFIG","Getting config database failed")

        apb_mon = APB_monitor::type_id::create("apb_mon",this);

        if (apb_cfg.is_active == UVM_ACTIVE) begin
            apb_drv = APB_driver::type_id::create("apb_drv",this);
            apb_seqr = APB_sequencer::type_id::create("apb_seqr",this);
        end
        super.build_phase(phase);
    endfunction: build_phase

    /////////////////////////////////////////////////////////////////////////////////////

    function void APB_agent::connect_phase(uvm_phase phase);
        if(apb_cfg.is_active == UVM_ACTIVE) begin
            apb_drv.seq_item_port.connect(apb_seqr.seq_item_export);
        end
    endfunction

///****************************************************************************************************///


