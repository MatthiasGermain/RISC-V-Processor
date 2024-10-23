library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_DMEM is
end entity tb_DMEM;

architecture behav of tb_DMEM is

	component DMEM
		generic 
		(
			DATA_WIDTH : natural := 32;
			ADDR_WIDTH : natural := 3  -- Mis à jour pour 8 mots
		);

		port 
		(
			clk	: in std_logic;
			addr	: in natural range 0 to 7;  -- Mis à jour pour 8 mots
			data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
			we		: in std_logic := '1';	
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
		);
	end component;

	signal addr_t : natural range 0 to 7; -- Mis à jour pour 8 mots
	signal q_t    : std_logic_vector(31 downto 0);  -- 32 bits
	signal data_t : std_logic_vector(31 downto 0);  -- 32 bits
	signal we_t   : std_logic :='1';
	signal clk_t  : std_logic := '0';

begin

	-- Instantiation of the DMEM
	ram_1 : DMEM
	generic map
	(
		DATA_WIDTH => 32,
		ADDR_WIDTH => 3  -- Mis à jour pour 8 mots
	)
	port map
	(
		clk	=> clk_t,
		addr	=> addr_t,
		q		=> q_t,
		data	=> data_t,
		we		=> we_t
	);

	-- Clock process
	clk_process : process
	begin
		clk_t <= not clk_t after 14 ns;
		wait for 14 ns;
	end process;

	-- Test process
	test_process : process
	begin
		-- Read the 8 words in ascending address order
		we_t <= '0';  -- Disable writing
		for i in 0 to 7 loop
			addr_t <= i;
			wait for 20 ns;
		end loop;

		-- Overwrite the values with 7 - address
		we_t <= '1';  -- Enable writing
		for i in 0 to 7 loop
			addr_t <= i;
			data_t <= std_logic_vector(to_unsigned(7 - i, 32));
			wait for 20 ns;
		end loop;

		-- Read the 8 words again in ascending address order
		we_t <= '0';  -- Disable writing
		for i in 0 to 7 loop
			addr_t <= i;
			wait for 20 ns;
		end loop;

		-- Stop the simulation
		wait;
	end process;

end architecture behav;
