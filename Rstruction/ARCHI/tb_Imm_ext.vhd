library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Imm_ext is
end tb_Imm_ext;

architecture Behavioral of tb_Imm_ext is
    -- Déclaration des signaux
    signal instr    : std_logic_vector(31 downto 0);
    signal instType : std_logic_vector(3 downto 0) := "0011"; -- Type I (4 bits, exemple: Type I instruction)
    signal immExt   : std_logic_vector(31 downto 0);

    -- Déclaration de la composante Imm_ext
    component Imm_ext
        port (
            instr    : in  std_logic_vector(31 downto 0);
            instType : in  std_logic_vector(3 downto 0);
            immExt   : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    -- Instanciation du module à tester (UUT)
    uut: Imm_ext
        port map (
            instr    => instr,
            instType => instType,
            immExt   => immExt
        );

    -- Processus de génération des stimuli
    stim_proc: process
    begin
        -- Test 1: Instruction 00000000110001100000000010010011
        instr <= "00000000110001100000000010010011";  -- Immédiat: 000000001100 (12 bits)
        wait for 10 ns;
        
        -- Test 2: Instruction 00101101000001100010000010010011
        instr <= "00101101000001100010000010010011";  -- Immédiat: 001011010000 (12 bits)
        wait for 10 ns;
        
        -- Test 3: Instruction 11111111110001100010000010010011 (immédiat négatif)
        instr <= "11111111110001100010000010010011";  -- Immédiat: 111111111100 (sign-extended)
        wait for 10 ns;
        
        -- Test 4: Instruction 00000000000001100010000010010011
        instr <= "00000000000001100010000010010011";  -- Immédiat: 000000000000 (zero immédiat)
        wait for 10 ns;

        -- Fin de la simulation
        wait;
    end process;
end architecture Behavioral;
