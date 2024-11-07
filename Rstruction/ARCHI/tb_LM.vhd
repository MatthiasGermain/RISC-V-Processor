library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_LM is
end tb_LM;

architecture Behavioral of tb_LM is
    -- Signals for the LM entity
    signal funct3   : std_logic_vector(2 downto 0);
    signal res      : std_logic_vector(1 downto 0);
    signal data     : std_logic_vector(31 downto 0);
    signal dataOut  : std_logic_vector(31 downto 0);

begin
    -- Instantiate the LM module
    uut: entity work.LM
        port map (
            funct3  => funct3,
            res     => res,
            data    => data,
            dataOut => dataOut
        );

    -- Test process
    process
    begin
        -- Test 1: Byte access with sign extension (funct3 = "000")
        funct3 <= "000";
        data <= x"12345678"; -- Sample data
        res <= "00";
        wait for 10 ns;
        assert dataOut = x"00000078" report "Byte access failed at res=00" severity error;
        
        res <= "01";
        wait for 10 ns;
        assert dataOut = x"00000056" report "Byte access failed at res=01" severity error;
        
        res <= "10";
        wait for 10 ns;
        assert dataOut = x"00000034" report "Byte access failed at res=10" severity error;
        
        res <= "11";
        wait for 10 ns;
        assert dataOut = x"00000012" report "Byte access failed at res=11" severity error;
        
        -- Test 2: Halfword access with sign extension (funct3 = "001")
        funct3 <= "001";
        data <= x"F2345678";
        
        res <= "00";
        wait for 10 ns;
        assert dataOut = x"00005678" report "Halfword access failed at res=00" severity error;

        res <= "10";
        wait for 10 ns;
        assert dataOut = x"00001234" report "Halfword access failed at res=10" severity error;

        -- Test 3: Word access (funct3 = "010")
        funct3 <= "010";
        data <= x"12345678";
        wait for 10 ns;
        assert dataOut = x"12345678" report "Word access failed" severity error;

        -- Test 4: Byte access without sign extension (funct3 = "100")
        funct3 <= "100";
        data <= x"F2345678"; -- Data with high byte set
        res <= "00";
        wait for 10 ns;
        assert dataOut = x"00000078" report "Unsigned byte access failed at res=00" severity error;

        res <= "11";
        wait for 10 ns;
        assert dataOut = x"000000F2" report "Unsigned byte access failed at res=11" severity error;

        -- Test 5: Halfword access without sign extension (funct3 = "101")
        funct3 <= "101";
        data <= x"F2345678";
        res <= "10";
        wait for 10 ns;
        assert dataOut = x"0000F234" report "Unsigned halfword access failed at res=10" severity error;

        -- End of simulation
        wait;
    end process;
end Behavioral;