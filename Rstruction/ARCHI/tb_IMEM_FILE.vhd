library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_IMEM_FILE is
end entity tb_IMEM_FILE;

architecture Behavioral of tb_IMEM_FILE is

    -- Paramètres pour l'instance d'IMEM
    constant DATA_WIDTH  : natural := 32;
    constant ADDR_WIDTH  : natural := 8;
    constant MEM_DEPTH   : natural := 100;
    constant INIT_FILE   : string := "or_02.hex"; -- Nom du fichier à utiliser

    -- Signaux pour la simulation
    signal address   : std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal Data_Out  : std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- Instance de la mémoire d'instructions IMEM
    component IMEM_FILE
        generic (
            DATA_WIDTH  : natural := 32;
            ADDR_WIDTH  : natural := 8;
            MEM_DEPTH   : natural := 100;
            INIT_FILE   : string
        );
        port (
            address     : in    std_logic_vector(ADDR_WIDTH - 1 downto 0);
            Data_Out    : out   std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;

begin

    -- Instanciation de l'entité IMEM
    uut: IMEM_FILE
        generic map (
            DATA_WIDTH  => DATA_WIDTH,
            ADDR_WIDTH  => ADDR_WIDTH,
            MEM_DEPTH   => MEM_DEPTH,
            INIT_FILE   => INIT_FILE  -- Fichier d'initialisation
        )
        port map (
            address     => address,
            Data_Out    => Data_Out
        );

    -- Processus de stimuli pour tester la mémoire d'instructions
    stimuli_process: process
    begin
        -- Test 1 : Lire l'adresse 0
        address <= (others => '0');  -- Adresse 0
        wait for 10 ns;
        
        -- Test 2 : Lire l'adresse 1
        address <= "00000001";  -- Adresse 1
        wait for 10 ns;

        -- Test 3 : Lire l'adresse 2
        address <= "00000010";  -- Adresse 2
        wait for 10 ns;

        -- Test 4 : Lire une autre adresse arbitraire (ex: 5)
        address <= "00000101";  -- Adresse 5
        wait for 10 ns;

        -- Fin de la simulation
        wait;
    end process;

end architecture Behavioral;
