library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_IMEM is
end entity tb_IMEM;

architecture behav of tb_IMEM is
	
    -- Déclaration du composant IMEM
    component IMEM
        generic 
        (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 5
        );
        port 
        (
            clk     : in std_logic;
            addr    : in natural range 0 to 2**ADDR_WIDTH - 1;
            q       : out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    end component;

    -- Déclaration des signaux
    signal addr_t : natural range 0 to 31;
    signal q_t : std_logic_vector(31 downto 0);  -- Sortie de 32 bits
    signal clk_t : std_logic := '0';

begin

    -- Instanciation du composant IMEM avec DATA_WIDTH = 32 bits
    rom_1 : IMEM
        generic map
        (
            DATA_WIDTH => 32,   -- Passage à 32 bits
            ADDR_WIDTH => 5
        )
        port map
        (
            clk  => clk_t,
            addr => addr_t,
            q    => q_t
        );
    
    -- Génération de l'horloge (période de 28 ns)
    clk_process : process
    begin
        clk_t <= not clk_t after 14 ns;
        wait for 14 ns;
    end process;
    
    -- Processus de test : Test des différentes adresses de la ROM
    test_process : process
    begin
        -- Test des valeurs aux différentes adresses
        addr_t <= 0;
        wait for 20 ns;
        addr_t <= 1;
        wait for 20 ns;
        addr_t <= 2;
        wait for 20 ns;
        addr_t <= 3;
        wait for 20 ns;
        addr_t <= 4;
        wait for 20 ns;
        addr_t <= 5;
        wait for 20 ns;
        addr_t <= 6;
        wait for 20 ns;
        addr_t <= 7;
        wait for 20 ns;
        addr_t <= 8;
        wait for 20 ns;
        addr_t <= 9;
        wait for 20 ns;
        addr_t <= 10;
        wait for 20 ns;

        -- Fin de simulation
        wait;
    end process;

end architecture behav;
