using System;
using System.IO;

public class BrainFuck {
	static void Main(string[] args) {
		foreach (string filename in args) {
			try {
			byte[] rom = File.ReadAllBytes(filename);
			byte[] tab = new byte[30000];
			int tabIndex = 0;
			for (int romIndex = 0; romIndex < rom.Length; romIndex++) {
				switch ((char) rom[romIndex]) {
				case '+':
					tab[tabIndex]++;
					break;
				case '-':
					tab[tabIndex]--;
					break;
				case '>':
					tabIndex++;
					break;
				case '<':
					tabIndex--;
					break;
				case '.':
					Console.Write((char) tab[tabIndex]);
					break;
				case ',':
					tab[tabIndex] = (byte) Console.Read();
					break;
				case '[':
					if (tab[tabIndex] == 0)
						romIndex = HandleLoop(rom, romIndex);
					break;
				case ']':
					if (tab[tabIndex] != 0)
						romIndex = HandleLoop(rom, romIndex);
					break;
				}
			}
			} catch (FileNotFoundException) {
				Console.WriteLine(filename + ": file not found");
			}
		}
	}
	
	static int HandleLoop(byte[] rom, int i) {
		int op = rom[i] == '[' ? 1 : -1;
		for (int counter = 0;; i += op) {
			if (rom[i] == '[')
				counter++;
			else if (rom[i] == ']')
				counter--;
			if (counter == 0) break;
		}
		return i;
	}
}
