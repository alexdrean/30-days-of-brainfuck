import java.nio.file.*;
import java.io.IOException;

class Main {
	public static void main(String[] args) {
		for (String filename : args) {
			try {
				byte[] rom = Files.readAllBytes(Paths.get(filename));
				byte[] tab = new byte[30000];
				for (int romIndex = 0, tabIndex = 0; romIndex < rom.length; romIndex++) {
					byte c = rom[romIndex];
					if (c == '+') tab[tabIndex]++;
					else if (c == '-') tab[tabIndex]--;
					else if (c == '>') tabIndex++;
					else if (c == '<') tabIndex--;
					else if (c == '.') System.out.write(tab[tabIndex]);
					else if (c == ',') {
						tab[tabIndex] = (byte) System.in.read();
					}
					else if (c == '[') {
						if (tab[tabIndex] == 0)
							romIndex = handleLoop(rom, romIndex);
					} else if (c == ']') {
						if (tab[tabIndex] != 0)
							romIndex = handleLoop(rom, romIndex);
					}
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
	}

	private static int handleLoop(byte[] rom, int romIndex) {
		int op = rom[romIndex] == '[' ? 1 : -1;
		for (int counter = 0;; romIndex += op) {
			byte c = rom[romIndex];
			if (c == '[') counter++;
			else if (c == ']') counter--;
			if (counter == 0) break;
		}
		return romIndex;
	}
}
