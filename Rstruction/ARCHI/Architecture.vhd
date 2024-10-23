library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_V_Processor is
    port (
        clk      : in  std_logic;                         -- Horloge du processeur
        reset    : in  std_logic;                         -- Reset global
        instr    : out std_logic_vector(31 downto 0);     -- Instruction actuelle
        result   : out std_logic_vector(31 downto 0)      -- Résultat de l'exécution
    );
end RISC_V_Processor;

architecture Behavioral of RISC_V_Processor is

    -- Déclaration des signaux pour connecter les différentes entités
    signal pc_out         : std_logic_vector(31 downto 0);
    signal instr_out      : std_logic_vector(31 downto 0);
    signal alu_result     : std_logic_vector(31 downto 0);
    signal reg_A, reg_B   : std_logic_vector(31 downto 0);
    signal aluOp          : std_logic_vector(3 downto 0);
    signal write_enable   : std_logic;
    signal load_pc        : std_logic;

    -- Instances des composants
    
    -- PC (Compteur de Programme)
    component PC is
        generic (
            N : integer := 32
        );
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            load         : in  std_logic;
            Write_Enable : in  std_logic;
            Data_In      : in  std_logic_vector(N-1 downto 0);
            Data_Out     : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Mémoire d'instructions
    component IMEM_FILE is
        generic (
            DATA_WIDTH  : natural := 32;
            ADDR_WIDTH  : natural := 8;
            MEM_DEPTH   : natural := 100;
            INIT_FILE   : string  := "add_02.hex.txt"
        );
        port (
            address  : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
            Data_Out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;

    -- Décodeur d'instructions
    component decodeur is
        port (
            instr       : in  std_logic_vector(31 downto 0);
            aluOp       : out std_logic_vector(3 downto 0);
            WriteEnable : out std_logic;
            load        : out std_logic
        );
    end component;

    -- Registre
    component REG is
        port (
            clk          : in  std_logic;
            Write_Enable : in  std_logic;
            RA           : in  std_logic_vector(4 downto 0);
            RB           : in  std_logic_vector(4 downto 0);
            RW           : in  std_logic_vector(4 downto 0);
            BusW         : in  std_logic_vector(31 downto 0);
            BusA         : out std_logic_vector(31 downto 0);
            BusB         : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Unité Arithmétique et Logique (ALU)
    component ALU is
        port (
            aluOp : in  std_logic_vector(3 downto 0);
            opA   : in  std_logic_vector(31 downto 0);
            opB   : in  std_logic_vector(31 downto 0);
            res   : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- Instance du PC
    u_PC : PC
        port map (
            clk          => clk,
            reset        => reset,
            load         => load_pc,
            Write_Enable => '1',  -- Incrément automatique de PC
            Data_In      => (others => '0'),
            Data_Out     => pc_out
        );

    -- Instance de la mémoire d'instructions (IMEM)
    u_IMEM : IMEM_FILE
        port map (
            address  => pc_out(7 downto 0),  -- Utilisation des bits d'adresse du PC
            Data_Out => instr_out
        );

    -- Instance du décodeur d'instructions
    u_decodeur : decodeur
        port map (
            instr       => instr_out,
            aluOp       => aluOp,
            WriteEnable => write_enable,
            load        => load_pc
        );

    -- Instance des registres
    u_REG : REG
        port map (
            clk          => clk,
            Write_Enable => write_enable,
            RA           => instr_out(19 downto 15),  -- Adresse source A
            RB           => instr_out(24 downto 20),  -- Adresse source B
            RW           => instr_out(11 downto 7),   -- Adresse destination
            BusW         => alu_result,               -- Résultat ALU
            BusA         => reg_A,
            BusB         => reg_B
        );

    -- Instance de l'ALU
    u_ALU : ALU
        port map (
            aluOp => aluOp,
            opA   => reg_A,
            opB   => reg_B,
            res   => alu_result
        );

    -- Assignation des sorties
    instr <= instr_out;   -- Instruction actuelle en sortie
    result <= alu_result; -- Résultat de l'ALU

end architecture Behavioral;