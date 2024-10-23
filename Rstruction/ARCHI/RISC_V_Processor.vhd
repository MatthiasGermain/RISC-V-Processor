library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_V_Processor is
    port (
        clk          : in  std_logic;                         -- Horloge du processeur
        reset        : in  std_logic;                         -- Reset 
        instr        : out std_logic_vector(31 downto 0);     -- Instruction actuelle
        result       : out std_logic_vector(31 downto 0);     -- Résultat de l'exécution
        -- Ports de débogage
        pc_out       : out std_logic_vector(31 downto 0);     -- Valeur du PC
        alu_result   : out std_logic_vector(31 downto 0);     -- Résultat ALU
        reg_A        : out std_logic_vector(31 downto 0);     -- Valeur du registre A
        reg_B        : out std_logic_vector(31 downto 0);     -- Valeur du registre B
        instr_out    : out std_logic_vector(31 downto 0);     -- Instruction actuelle dans IMEM
        aluOp        : out std_logic_vector(3 downto 0);      -- Code d'opération ALU
        write_enable : out std_logic;                         -- Signal d'écriture dans les registres
        load_pc      : out std_logic;                         -- Signal de chargement du PC
        -- Signaux de debug
        debug_RA     : out std_logic_vector(4 downto 0);      -- Debug: Adresse du registre source A
        debug_RB     : out std_logic_vector(4 downto 0);      -- Debug: Adresse du registre source B
        debug_RW     : out std_logic_vector(4 downto 0)       -- Debug: Adresse du registre destination
    );
end RISC_V_Processor;

architecture Behavioral of RISC_V_Processor is

    -- Déclaration des signaux pour connecter les différentes entités internes
    signal pc_internal      : std_logic_vector(31 downto 0);
    signal instr_internal   : std_logic_vector(31 downto 0);
    signal immExt_internal  : std_logic_vector(31 downto 0);
    signal RI_sel_internal  : std_logic;
    signal alu_result_internal : std_logic_vector(31 downto 0);
    signal reg_A_internal, reg_B_internal : std_logic_vector(31 downto 0);
    signal aluOp_internal   : std_logic_vector(3 downto 0);
    signal write_enable_internal : std_logic;
    signal load_pc_internal : std_logic;

    -- Signaux de débogage internes
    signal RA_internal, RB_internal, RW_internal : std_logic_vector(4 downto 0);

    -- Signal temporaire pour le multiplexeur
    signal mux_out_internal : std_logic_vector(31 downto 0);

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

    -- Mémoire d'instructions (IMEM)
    component IMEM_FILE is
        generic (
            DATA_WIDTH  : natural := 32;
            ADDR_WIDTH  : natural := 8;
            MEM_DEPTH   : natural := 100;
            INIT_FILE   : string  := "add_01.hex"
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
            load        : out std_logic;
            RI_sel      : out std_logic                       
        );
    end component;

    -- Imm_ext
    component Imm_ext is
        port (
            instr    : in  std_logic_vector(31 downto 0);  -- 32-bit instruction input
            instType : in  std_logic_vector(3 downto 0);   --
            immExt   : out std_logic_vector(31 downto 0)   -- 32-bit sign-extended immediate output
        );
    end component;

    -- mux2to1
    component mux2to1 is
        port (
            sel      : in  std_logic;                      -- Sélection du multiplexeur
            mux_in1  : in  std_logic_vector(31 downto 0);  -- Entrée 1
            mux_in2  : in  std_logic_vector(31 downto 0);  -- Entrée 2
            mux_out  : out std_logic_vector(31 downto 0)   -- Sortie
        );
    end component;

    -- Registres
    component REG is
        port (
            clk          : in  std_logic;
            Write_Enable : in  std_logic;
            RA           : in  std_logic_vector(4 downto 0);       -- Adresse source A
            RB           : in  std_logic_vector(4 downto 0);       -- Adresse source B
            RW           : in  std_logic_vector(4 downto 0);       -- Adresse destination
            BusW         : in  std_logic_vector(31 downto 0);      -- Données à écrire
            BusA         : out std_logic_vector(31 downto 0);      -- Valeur lue du registre RA
            BusB         : out std_logic_vector(31 downto 0)       -- Valeur lue du registre RB
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
            load         => load_pc_internal,
            Write_Enable => '1',  -- Incrément automatique de PC
            Data_In      => (others => '0'),
            Data_Out     => pc_internal
        );

    -- Instance de la mémoire d'instructions (IMEM)
    u_IMEM : IMEM_FILE
        port map (
            address  => pc_internal(7 downto 0),  -- Utilisation des bits d'adresse du PC
            Data_Out => instr_internal
        );

    -- Instance du décodeur d'instructions
    u_decodeur : decodeur
        port map (
            instr       => instr_internal,
            aluOp       => aluOp_internal,
            WriteEnable => write_enable_internal,
            load        => load_pc_internal,
            RI_sel      => RI_sel_internal
        );

    -- Instance de Imm_ext
    u_Imm_ext : Imm_ext    
        port map (
            instr    => instr_internal,
            instType => (others => '0'),
            immExt   => immExt_internal
        );

    -- Instance de mux2to1
    u_mux2to1 : mux2to1    
        port map (
            sel => RI_sel_internal,
            mux_in1 => reg_B_internal,
            mux_in2 => immExt_internal,
            mux_out => mux_out_internal -- Utilisez le signal temporaire ici
        );

    -- Instance des registres
    u_REG : REG
        port map (
            clk          => clk,
            Write_Enable => write_enable_internal,
            RA           => instr_internal(19 downto 15),  -- Adresse source A
            RB           => instr_internal(24 downto 20),  -- Adresse source B
            RW           => instr_internal(11 downto 7),   -- Adresse destination
            BusW         => alu_result_internal,           -- Résultat ALU
            BusA         => reg_A_internal,
            BusB         => reg_B_internal -- Utilisez le signal temporaire ici
        );

    -- Instance de l'ALU
    u_ALU : ALU
        port map (
            aluOp => aluOp_internal,
            opA   => reg_A_internal,
            opB   => mux_out_internal, -- Utilisez le signal temporaire ici
            res   => alu_result_internal
        );

    -- Assignation des signaux internes pour déboguer les adresses RA, RB et RW
    RA_internal <= instr_internal(19 downto 15);  -- Debug: RA
    RB_internal <= instr_internal(24 downto 20);  -- Debug: RB
    RW_internal <= instr_internal(11 downto 7);   -- Debug: RW

    -- Assignation des sorties de débogage
    debug_RA <= RA_internal;
    debug_RB <= RB_internal;
    debug_RW <= RW_internal;

    -- Assignation des résultats finaux
    instr <= instr_internal;
    result <= alu_result_internal;
    pc_out <= pc_internal;
    alu_result <= alu_result_internal;
    reg_A <= reg_A_internal;
    reg_B <= reg_B_internal;

end architecture Behavioral;
