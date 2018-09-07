require 'io/console'

for filename in ARGV
	rom = File.read(filename)
	compiled = "tab = Array.new(30000){0}\ntabIndex = 0\n"
	rom.each_byte do |c|
		case c
		when '>'.ord
			compiled << "tabIndex+=1\n"
		when '<'.ord
			compiled << "tabIndex-=1\n"
		when '+'.ord
			compiled << "tab[tabIndex]+=1\ntab[tabIndex] = 0 if tab[tabIndex] == 256\n"
		when '-'.ord
			compiled << "tab[tabIndex]-=1\ntab[tabIndex] = 255 if tab[tabIndex] == -1\n"
		when '.'.ord
			compiled << "putc(tab[tabIndex].chr)\n"
		when ','.ord
			compiled << "tab[tabIndex] = STDIN.getc.ord\n"
		when '['.ord
			compiled << "while tab[tabIndex] != 0\n"
		when ']'.ord
			compiled << "end\n"
		end
	end
	eval compiled
end
