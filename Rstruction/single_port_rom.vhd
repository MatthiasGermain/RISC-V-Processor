-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_rom is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 8
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of single_port_rom is

	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_rom
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize each address with the address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));
		end loop;
		tmp(0) := x"FF";
		tmp(1) := x"AA";
		tmp(2) := x"BB";
		tmp(3) := x"CC";
		tmp(4) := x"DD";
		tmp(5) := x"EE";
		tmp(6) := x"FA";
		tmp(7) := x"FB";
		tmp(8) := x"FC";
		tmp(9) := x"FD";
		tmp(10) := x"FE";
		tmp(11) := x"AB";
		tmp(12) := x"AC";
		return tmp;
	end init_rom;	 

	-- Declare the ROM signal and specify a default value.	Quartus Prime
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t := init_rom;

begin

	--process(clk)
	process(addr)
	begin
	--if(rising_edge(clk)) then
		q <= rom(addr);
	--end if;
	end process;

end rtl;
