class APB_agent_top extends uvm_env;

    `uvm_component_utils (APB_agent_top)

    bridge_env_config e_cfg;
    APB_agent_config a_cfg[];
    APB_agent apb_agt[];

    extern function new(string name = "APB_agent_top", uvm_component parent);
    extern function void build_phase(uvm_phase phase); 
endclass

    //////////////////////////////////////////////////////////////////////////////

    function APB_agent_top::new(string name = "APB_agent_top", uvm_component parent);
        super.new(name, parent);
    endfunction

    ///////////////////////////////////////////////////////////////////////////////

    function void APB_agent_top::build_phase(uvm_phase phase);

        if (!uvm_config_db #(bridge_env_config)::get(this, "", "bridge_env_config",e_cfg))
            `uvm_fatal("CONFIG", "getting database failed")

        apb_agt = new[e_cfg.APB_Agents];
        a_cfg = new[e_cfg.APB_Agents];

        foreach(apb_agt[i]) begin
            apb_agt[i] = APB_agent::type_id::create($sformatf("apb_agt[%0d]",i), this);
            a_cfg[i] = APB_agent_config::type_id::create($sformatf("a_cfg[%0d]",i));
            a_cfg[i] = e_cfg.s_cfg[i];
            uvm_config_db #(APB_agent_config)::set(this, $sformatf("apb_agt[%0d]*",i),"APB_agent_config",a_cfg[i]);
        end

        super.build_phase(phase);
    endfunction

///****************************************************************************************************///
