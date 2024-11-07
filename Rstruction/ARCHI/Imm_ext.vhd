library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Imm_ext is
    port (
        instr    : in  std_logic_vector(31 downto 0);  -- 32-bit instruction input
        instType : in  std_logic_vector(3 downto 0);   -- 
        immExt   : out std_logic_vector(31 downto 0)   -- 32-bit sign-extended immediate output
    );
end entity Imm_ext;

architecture Behavioral of Imm_ext is
begin

    process(instr)
    begin
		 immExt <= std_logic_vector(resize(signed(instr(31 downto 20)), 32)); 
    end process;
end architecture Behavioral;
