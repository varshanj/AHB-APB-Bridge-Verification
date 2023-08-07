class APB_sequence extends uvm_sequence #(APB_xtn);

    `uvm_object_utils (APB_sequence)

    function new(string name = "APB_sequence");
        super.new(name);
    endfunction
 
endclass

///***********************************************************************///

class extended_apb_sequence extends APB_sequence;

    `uvm_object_utils (extended_apb_sequence)

    extern function new(string name = "extended_apb_sequence");
    extern task body();

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function extended_apb_sequence::new(string name = "extended_apb_sequence");
        super.new(name);
    endfunction

    /////////////////////////////////////////////////////////////////////////////////////

    task extended_apb_sequence::body();
        begin
            req = APB_xtn::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
    endtask

///***********************************************************************///
