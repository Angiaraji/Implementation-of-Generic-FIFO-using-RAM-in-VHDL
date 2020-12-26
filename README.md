# Implementation-of-generic-FIFO-using-RAM-in-VHDL

Design of a generic FIFO (fist-in-first-out) memory in VHDL by realising it as ring buffer. 
The attached RAM implementation (ram_si_so_irwa.vhd) is used for the implementation.
The given ram has a fixed data width of 8 bit (din, dout are defined as 7 downto 0) and can hold 32 bytes
(din_addr, dout_addr are defined as 4 downto 0 -> 32 different addresses possible).
The interface of the FIFO is depicted below.

All ports, that are in bold font, as well as the depth of the FIFO are configurable. 
The bit width of the data input and output shall be a multiple of 8, the depth of the FIFO shall be a multiple of 32.
For the almost full/empty flags (afull, aempty) it shall be configurable, 
how much data words can be written after afull was asserted until the FIFO is full or
how much data words can still be read after aempty is asserted until the FIFO is empty.
