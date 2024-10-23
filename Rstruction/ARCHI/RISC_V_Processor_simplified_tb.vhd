library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_V_Processor_simplified_tb is
end RISC_V_Processor_simplified_tb;

architecture Behavioral of RISC_V_Processor_simplified_tb is

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
            clk          : in  std_logic;
            reset        : in  std_logic;
            instr        : out std_logic_vector(31 downto 0);
            result       : out std_logic_vector(31 downto 0);
            
            -- Debug ports
            pc_out         : out std_logic_vector(31 downto 0);
            alu_result     : out std_logic_vector(31 downto 0);
            reg_A          : out std_logic_vector(31 downto 0);
            reg_B          : out std_logic_vector(31 downto 0);
            instr_out      : out std_logic_vector(31 downto 0);
            aluOp          : out std_logic_vector(3 downto 0);
            write_enable   : out std_logic;
            load_pc        : out std_logic;
            -- Signaux de debug pour RA, RB et RW
            debug_RA       : out std_logic_vector(4 downto 0);
            debug_RB       : out std_logic_vector(4 downto 0);
            debug_RW       : out std_logic_vector(4 downto 0)
        );
    end component;

begin

    -- Instanciation du processeur RISC-V avec signaux de debug
    uut : RISC_V_Processor
        port map (
            clk          => clk_tb,
            reset        => reset_tb,
            instr        => instr_tb,
            result       => result_tb
        );

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
        wait;
    end process;

end architecture Behavioral;
