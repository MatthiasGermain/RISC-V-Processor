library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_V_Processor_tb is
end RISC_V_Processor_tb;

architecture Behavioral of RISC_V_Processor_tb is

    -- Composants du testbench
    signal clk_tb      : std_logic := '0';
    signal reset_tb    : std_logic := '0';
    signal instr_tb    : std_logic_vector(31 downto 0);
    signal result_tb   : std_logic_vector(31 downto 0);

    -- Constantes pour le timing
    constant clk_period : time := 10 ns;

    -- Instance du processeur
    component RISC_V_Processor
        port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            instr    : out std_logic_vector(31 downto 0);
            result   : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- Génération de l'horloge
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    -- Simulation du comportement du processeur
    stim_process : process
    begin
        -- Initialisation
        reset_tb <= '1';  -- Activer le reset
        wait for 20 ns;    -- Attendre un peu
        reset_tb <= '0';  -- Désactiver le reset

        -- Simuler des instructions à travers la mémoire d'instructions
        wait for 100 ns;

        -- Ajouter d'autres scénarios si nécessaire
        -- (exemple : vérification des résultats ALU, registres, etc.)

        wait for 500 ns;
        wait;
    end process;

    -- Instanciation du processeur RISC-V
    uut : RISC_V_Processor
        port map (
            clk      => clk_tb,
            reset    => reset_tb,
            instr    => instr_tb,
            result   => result_tb
        );

end architecture Behavioral;
