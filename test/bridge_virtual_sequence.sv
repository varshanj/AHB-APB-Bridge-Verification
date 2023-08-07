class bridge_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils (bridge_virtual_sequence)

    bridge_env_config cfg;
    bridge_virtual_sequencer v_seqrh;
    AHB_sequencer m_seqr[];
    APB_sequencer s_seqr[];

    function new (string name = "virtual_sequence");
        super.new(name);
    endfunction

    task body();
        if(!uvm_config_db #(bridge_env_config)::get(null,get_full_name(),"bridge_env_config",cfg))
            `uvm_fatal("CONFIG", "Getting config database failed")

        m_seqr = new[cfg.AHB_Agents];
        s_seqr = new[cfg.APB_Agents];

        assert($cast(v_seqrh, m_sequencer))
        else 
            `uvm_error("BODY","Casting failed")

        foreach (m_seqr[i]) 
            m_seqr[i] = v_seqrh.m_seqr[i];

        foreach (s_seqr[i]) 
            s_seqr[i] = v_seqrh.s_seqr[i];

    endtask
endclass

///****************************************************************************************************///

class v_seq_ext1 extends bridge_virtual_sequence;

    `uvm_object_utils (v_seq_ext1)

    single_transfer_seq m_seq;
    //extended_slave_sequence1 s_seq;

    extern function new (string name = "v_seq_ext1");
    extern task body();
endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function v_seq_ext1::new (string name = "v_seq_ext1");
        super.new(name);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task v_seq_ext1::body();

        super.body();
        m_seq = single_transfer_seq::type_id::create("m_seq");
        //s_seq = extended_slave_sequence1::type_id::create("s_seq");
        m_seq.start(m_seqr[0]);
    endtask

///****************************************************************************************************///

class v_seq_ext2 extends bridge_virtual_sequence;

    `uvm_object_utils (v_seq_ext2)

    unspecified_transfer_seq m_seq;
    //extended_slave_sequence1 s_seq;

    extern function new (string name = "v_seq_ext2");
    extern task body();
endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function v_seq_ext2::new (string name = "v_seq_ext2");
        super.new(name);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task v_seq_ext2::body();

        super.body();
        m_seq = unspecified_transfer_seq::type_id::create("m_seq");
        //s_seq = extended_slave_sequence1::type_id::create("s_seq");
        m_seq.start(m_seqr[0]);
    endtask

///****************************************************************************************************///

class v_seq_ext3 extends bridge_virtual_sequence;

    `uvm_object_utils (v_seq_ext3)

    incremental_transfer_seq m_seq;
    //extended_slave_sequence1 s_seq;

    extern function new (string name = "v_seq_ext3");
    extern task body();
endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function v_seq_ext3::new (string name = "v_seq_ext3");
        super.new(name);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task v_seq_ext3::body();

        super.body();
        m_seq = incremental_transfer_seq::type_id::create("m_seq");
        //s_seq = extended_slave_sequence1::type_id::create("s_seq");
        m_seq.start(m_seqr[0]);
    endtask

///****************************************************************************************************///

class v_seq_ext4 extends bridge_virtual_sequence;

    `uvm_object_utils (v_seq_ext4)

    wrap_transfer_seq m_seq;
    //extended_slave_sequence1 s_seq;

    extern function new (string name = "v_seq_ext4");
    extern task body();
endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function v_seq_ext4::new (string name = "v_seq_ext4");
        super.new(name);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task v_seq_ext4::body();

        super.body();
        m_seq = wrap_transfer_seq::type_id::create("m_seq");
        //s_seq = extended_slave_sequence1::type_id::create("s_seq");
        m_seq.start(m_seqr[0]);
    endtask

///****************************************************************************************************///


