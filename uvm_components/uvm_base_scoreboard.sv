// UVM Base Scoreboard
// Generic scoreboard component for checking DUT behavior

`ifndef UVM_BASE_SCOREBOARD_SV
`define UVM_BASE_SCOREBOARD_SV

class uvm_base_scoreboard #(type T = uvm_sequence_item) extends uvm_scoreboard;
  
  `uvm_component_param_utils(uvm_base_scoreboard #(T))
  
  // Analysis imports
  uvm_analysis_imp #(T, uvm_base_scoreboard #(T)) analysis_export;
  
  // Queues for expected and actual transactions
  T expected_queue[$];
  T actual_queue[$];
  
  // Statistics
  int matches;
  int mismatches;
  int dropped;
  
  // Constructor
  function new(string name = "uvm_base_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
    matches = 0;
    mismatches = 0;
    dropped = 0;
  endfunction
  
  // Write method for analysis import
  virtual function void write(T trans);
    actual_queue.push_back(trans);
    check_transaction(trans);
  endfunction
  
  // Check transaction against expected
  virtual function void check_transaction(T trans);
    T expected;
    
    if (expected_queue.size() > 0) begin
      expected = expected_queue.pop_front();
      
      if (compare_transactions(trans, expected)) begin
        matches++;
        `uvm_info(get_type_name(), $sformatf("Transaction MATCH [%0d matches]", matches), UVM_MEDIUM)
      end
      else begin
        mismatches++;
        `uvm_error(get_type_name(), 
          $sformatf("Transaction MISMATCH [%0d mismatches]\nExpected: %s\nActual: %s", 
            mismatches, expected.convert2string(), trans.convert2string()))
      end
    end
    else begin
      dropped++;
      `uvm_warning(get_type_name(), 
        $sformatf("No expected transaction for actual [%0d dropped]", dropped))
    end
  endfunction
  
  // Compare two transactions - to be overridden
  virtual function bit compare_transactions(T actual, T expected);
    return actual.compare(expected);
  endfunction
  
  // Add expected transaction
  virtual function void add_expected(T trans);
    expected_queue.push_back(trans);
  endfunction
  
  // Report phase
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    `uvm_info(get_type_name(), 
      $sformatf("Scoreboard Summary:\n  Matches: %0d\n  Mismatches: %0d\n  Dropped: %0d", 
        matches, mismatches, dropped), UVM_LOW)
    
    if (mismatches > 0) begin
      `uvm_error(get_type_name(), $sformatf("Test FAILED with %0d mismatches", mismatches))
    end
    else if (matches == 0) begin
      `uvm_warning(get_type_name(), "No transactions checked!")
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("Test PASSED with %0d matches", matches), UVM_LOW)
    end
  endfunction
  
  // Check phase - verify all expected transactions were received
  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    
    if (expected_queue.size() > 0) begin
      `uvm_error(get_type_name(), 
        $sformatf("%0d expected transactions not received", expected_queue.size()))
    end
  endfunction
  
endclass

`endif // UVM_BASE_SCOREBOARD_SV
