class APB_xtn extends uvm_sequence_item;

    `uvm_object_utils (APB_xtn)

    logic Penable, Pwrite;
    logic [3:0] Pselx;
    logic [31:0] Pwdata, Prdata, Paddr;

    extern function new(string name = "APB_xtn");
    extern function void do_print (uvm_printer printer);

endclass

    /////////////////////////////////////////////////////////////////////////////////////

    function APB_xtn::new(string name ="APB_xtn");
        super.new(name);
    endfunction: new

    /////////////////////////////////////////////////////////////////////////////////////

    function void APB_xtn::do_print(uvm_printer printer);
        printer.print_field("Paddr",  Paddr, 32, UVM_HEX);
        printer.print_field("Pwdata", Pwdata, 32, UVM_HEX);
        printer.print_field("Prdata", Prdata, 32, UVM_HEX);
        printer.print_field("Pwrite", Pwrite, 1, UVM_DEC);      
    endfunction

///****************************************************************************************************///

