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

    -- Debug signals
    signal pc_out_tb       : std_logic_vector(31 downto 0);  -- PC value
    signal alu_result_tb   : std_logic_vector(31 downto 0);  -- ALU result
    signal reg_A_tb        : std_logic_vector(31 downto 0);  -- Register A value
    signal reg_B_tb        : std_logic_vector(31 downto 0);  -- Register B value
    signal instr_out_tb    : std_logic_vector(31 downto 0);  -- Current instruction
    signal aluOp_tb        : std_logic_vector(3 downto 0);   -- ALU operation code
    signal write_enable_tb : std_logic;                      -- Write enable signal for registers
    signal load_pc_tb      : std_logic;                      -- PC load signal

    -- Debug signals for RA, RB, RW
    signal RA_tb           : std_logic_vector(4 downto 0);   -- Debug: Adresse du registre source A
    signal RB_tb           : std_logic_vector(4 downto 0);   -- Debug: Adresse du registre source B
    signal RW_tb           : std_logic_vector(4 downto 0);   -- Debug: Adresse du registre destination

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

    -- Instanciation du processeur RISC-V avec signaux de debug
    uut : RISC_V_Processor
        port map (
            clk          => clk_tb,
            reset        => reset_tb,
            instr        => instr_tb,
            result       => result_tb,
            -- Debug connections
            pc_out       => pc_out_tb,
            alu_result   => alu_result_tb,
            reg_A        => reg_A_tb,
            reg_B        => reg_B_tb,
            instr_out    => instr_out_tb,
            aluOp        => aluOp_tb,
            write_enable => write_enable_tb,
            load_pc      => load_pc_tb,
            -- Connexions des signaux de débogage RA, RB, RW
            debug_RA     => RA_tb,
            debug_RB     => RB_tb,
            debug_RW     => RW_tb
        );

end architecture Behavioral;
