library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        aluOp : in std_logic_vector(3 downto 0);  -- Code opératoire ALU
        opA   : in std_logic_vector(31 downto 0); -- Première entrée
        opB   : in std_logic_vector(31 downto 0); -- Deuxième entrée
        res   : out std_logic_vector(31 downto 0)  -- Résultat en sortie
    );
end entity ALU;

architecture Behavioral of ALU is
begin

    process(opA, opB, aluOp)
    begin
        case aluOp is
            when "0000" =>  -- Addition
                res <= std_logic_vector(signed(opA) + signed(opB));
            when "0001" =>  -- Soustraction
                res <= std_logic_vector(signed(opA) - signed(opB));
            when "1001" =>  -- AND
                res <= opA and opB;
            when "1000" =>  -- OR
                res <= opA or opB;
            when "0101" =>  -- XOR
                res <= opA xor opB;
            when "0010" =>  -- Décalage à gauche (sll)
                res <= std_logic_vector(shift_left(signed(opA), to_integer(unsigned(opB(4 downto 0)))));  -- Assure-toi que le décalage est fait correctement
            when "0110" =>  -- Décalage à droite logique (srl)
                res <= std_logic_vector(shift_right(signed(opA), to_integer(unsigned(opB(4 downto 0)))));
            when "0111" =>  -- Décalage à droite arithmétique (sra)
                res <= std_logic_vector(shift_right(signed(opA), to_integer(unsigned(opB(4 downto 0)))));
				when "0011" =>  -- Set on Less Than (slt)
                if signed(opA) < signed(opB) then
                    res <= (others => '1');  -- Si opA < opB, mettre res à 1
                else
                    res <= (others => '0');  -- Sinon, mettre res à 0
                end if;
				when "0100" =>  -- Set on Less Than Unsigned (sltu)
                if unsigned(opA) < unsigned(opB) then
                    res <= (others => '1');  -- Si opA < opB, mettre res à 1
                else
                    res <= (others => '0');  -- Sinon, mettre res à 0
                end if;
            when others =>
                res <= (others => '0');  -- Valeur par défaut
        end case;
    end process;

end architecture Behavioral;
