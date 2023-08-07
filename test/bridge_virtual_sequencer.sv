class bridge_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

    `uvm_component_utils (bridge_virtual_sequencer)

    bridge_env_config s_cfg;
    AHB_sequencer m_seqr[];
    APB_sequencer s_seqr[];

    function new(string name = "bridge_virtual_sequencer",  uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(bridge_env_config)::get(null,get_full_name(),"bridge_env_config",s_cfg))
                `uvm_fatal("CONFIG", "Getting config database failed")

        m_seqr = new[s_cfg.AHB_Agents];
        s_seqr = new[s_cfg.APB_Agents];

    endfunction
endclass
