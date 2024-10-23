library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ALU is
end entity tb_ALU;

architecture Behavioral of tb_ALU is

    -- Déclarations des signaux
    signal aluOp : std_logic_vector(3 downto 0);
    signal opA   : std_logic_vector(31 downto 0);
    signal opB   : std_logic_vector(31 downto 0);
    signal res    : std_logic_vector(31 downto 0);

    -- Instanciation de l'entité ALU
    component ALU is
        port (
            aluOp : in std_logic_vector(3 downto 0);
            opA   : in std_logic_vector(31 downto 0);
            opB   : in std_logic_vector(31 downto 0);
            res    : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- Instanciation de l'ALU
    uut: ALU
        port map (
            aluOp => aluOp,
            opA   => opA,
            opB   => opB,
            res    => res
        );

    -- Processus de test
    process
    begin
        -- Test Addition
        aluOp <= "0000";  -- Code pour addition
        opA <= "00000000000000000000000000000101"; -- 5
        opB <= "00000000000000000000000000000011"; -- 3
        wait for 10 ns;  -- Attendre 10 ns
        assert (res = "00000000000000000000000000001000") report "Erreur: addition incorrecte" severity error;  -- 5 + 3 = 8

        -- Test Soustraction
        aluOp <= "0001";  -- Code pour soustraction
        opA <= "00000000000000000000000000001000"; -- 8
        opB <= "00000000000000000000000000000011"; -- 3
        wait for 10 ns;
        assert (res = "00000000000000000000000000000101") report "Erreur: soustraction incorrecte" severity error;  -- 8 - 3 = 5

        -- Test AND
        aluOp <= "0010";  -- Code pour AND
        opA <= "00000000000000000000000000001101"; -- 13
        opB <= "00000000000000000000000000000111"; -- 7
        wait for 10 ns;
        assert (res = "00000000000000000000000000000101") report "Erreur: AND incorrect" severity error;  -- 13 AND 7 = 5

        -- Test OR
        aluOp <= "0011";  -- Code pour OR
        opA <= "00000000000000000000000000001101"; -- 13
        opB <= "00000000000000000000000000000111"; -- 7
        wait for 10 ns;
        assert (res = "00000000000000000000000000001111") report "Erreur: OR incorrect" severity error;  -- 13 OR 7 = 15

        -- Test XOR
        aluOp <= "0100";  -- Code pour XOR
        opA <= "00000000000000000000000000001101"; -- 13
        opB <= "00000000000000000000000000000111"; -- 7
        wait for 10 ns;
        assert (res = "00000000000000000000000000001010") report "Erreur: XOR incorrect" severity error;  -- 13 XOR 7 = 10

        -- Test Décalage à gauche (sll)
        aluOp <= "0101";  -- Code pour sll
        opA <= "00000000000000000000000000000001"; -- 1
        opB <= "00000000000000000000000000000010"; -- Décalage de 2
        wait for 10 ns;
        assert (res = "00000000000000000000000000000100") report "Erreur: sll incorrect" severity error;  -- 1 << 2 = 4

        -- Test Décalage à droite logique (srl)
        aluOp <= "0110";  -- Code pour srl
        opA <= "00000000000000000000000000010000"; -- 16
        opB <= "00000000000000000000000000000001"; -- Décalage de 1
        wait for 10 ns;
        assert (res = "00000000000000000000000000001000") report "Erreur: srl incorrect" severity error;  -- 16 >> 1 = 8

        -- Test Décalage à droite arithmétique (sra)
        aluOp <= "0111";  -- Code pour sra
        opA <= "11111111111111111111111111110000"; -- -16 (signe)
        opB <= "00000000000000000000000000000001"; -- Décalage de 1
        wait for 10 ns;
        assert (res = "11111111111111111111111111111000") report "Erreur: sra incorrect" severity error;  -- -16 sra 1 = -8

        -- Fin des tests
        wait;
    end process;

end architecture Behavioral;
