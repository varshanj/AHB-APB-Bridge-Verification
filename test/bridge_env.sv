class bridge_env extends uvm_env;

    `uvm_component_utils (bridge_env) 

    bridge_env_config e_cfg;
    AHB_agent_top ahb_agt_top;
    APB_agent_top apb_agt_top;
    bridge_virtual_sequencer env_v_seqr;
    bridge_scoreboard sb;

    extern function new(string name = "bridge_env", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

    /////////////////////////////////////////////////////////////////////////////////////
    
    function bridge_env::new(string name = "bridge_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////
    
    function void bridge_env::build_phase(uvm_phase phase);

        if (!uvm_config_db #(bridge_env_config)::get(this, "", "bridge_env_config",e_cfg))
            `uvm_fatal("CONFIG","Getting config database failed")

        if (e_cfg.has_virtual_sequencer) begin
            env_v_seqr = bridge_virtual_sequencer::type_id::create("env_v_seqr",this);
            ahb_agt_top = AHB_agent_top::type_id::create("ahb_agt_top", this);
            apb_agt_top = APB_agent_top::type_id::create("apb_agt_top",this);
        end

        if(e_cfg.has_scoreboard)
            sb = bridge_scoreboard::type_id::create("sb",this);

        super.build_phase(phase);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    function void bridge_env::connect_phase(uvm_phase phase);

        if (e_cfg.has_virtual_sequencer) begin
            for (int k = 0; k < e_cfg.AHB_Agents; k++) begin 
                env_v_seqr.m_seqr[k] = ahb_agt_top.ahb_agt[k].ahb_seqr;
            end

            for (int j = 0; j < e_cfg.APB_Agents; j++) begin 
                env_v_seqr.s_seqr[j] = apb_agt_top.apb_agt[j].apb_seqr;
            end
        end

        if (e_cfg.has_scoreboard) begin
            for (int i = 0; i < e_cfg.AHB_Agents; i++) begin 
                ahb_agt_top.ahb_agt[i].ahb_mon.monitor_port.connect(sb.AHB_fifo[i].analysis_export);
            end

            for (int i = 0; i < e_cfg.APB_Agents; i++) begin 
                apb_agt_top.apb_agt[i].apb_mon.monitor_port.connect(sb.APB_fifo[i].analysis_export);
            end
        end
        super.connect_phase(phase);
    endfunction

///*********************************************************************************************************//
