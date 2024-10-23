-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mem is
end entity tb_mem;

architecture behav of tb_mem is

	component single_port_rom

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

	end component;
	
	signal addr_t : natural range 0 to 255;
	signal q_t : std_logic_vector (7 downto 0);
	signal clk_t : std_logic:='0';
	
begin

	rom_1 : single_port_rom
	
	generic map
	(
		DATA_WIDTH => 8,
		ADDR_WIDTH => 8
	)
	
	port map
	(
		clk	=> clk_t,
		addr	=> addr_t,
		q		=> q_t
	);
	
clk_t <= not clk_t after 14 ns;

addr_t <= 0, 1 after 20 ns, 2 after 40 ns, 3 after 60 ns, 4 after 80 ns, 5 after 100 ns, 6 after 120 ns, 7 after 140 ns, 8 after 160 ns, 9 after 180 ns, 10 after 200 ns; 
	
	
end behav; 
