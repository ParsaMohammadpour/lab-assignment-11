library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity elevator is
port (
	    sw    :  in  std_logic_vector(7 downto 0);
        led :  out std_logic_vector(7 downto 0) );
end entity elevator;

architecture behavioral of elevator is

begin
	led <= sw;
end behavioral;