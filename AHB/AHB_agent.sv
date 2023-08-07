class AHB_agent extends uvm_agent;

    `uvm_component_utils (AHB_agent)

    AHB_agent_config ahb_cfg;
    AHB_driver ahb_drv;
    AHB_monitor ahb_mon;
    AHB_sequencer ahb_seqr;

    extern function new(string name = "AHB_agent",  uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function AHB_agent::new(string name = "AHB_agent",uvm_component parent);
        super.new(name,parent);
    endfunction: new

    /////////////////////////////////////////////////////////////////////////////////////

    function void AHB_agent::build_phase(uvm_phase phase);
        if(!uvm_config_db #(AHB_agent_config)::get(this,"","AHB_agent_config",ahb_cfg))
            `uvm_fatal("CONFIG","Getting config database failed")
        ahb_mon = AHB_monitor::type_id::create("ahb_mon",this);

        if(ahb_cfg.is_active == UVM_ACTIVE) begin
            ahb_drv = AHB_driver::type_id::create("ahb_drv",this);
            ahb_seqr = AHB_sequencer::type_id::create("ahb_seqr",this);
        end
        super.build_phase(phase);
    endfunction: build_phase

    /////////////////////////////////////////////////////////////////////////////////////

    function void AHB_agent::connect_phase(uvm_phase phase);
        if(ahb_cfg.is_active == UVM_ACTIVE) begin
            ahb_drv.seq_item_port.connect(ahb_seqr.seq_item_export);
        end
    endfunction

///****************************************************************************************************///


