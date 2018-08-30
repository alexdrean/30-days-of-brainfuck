const fs = require('fs')
const fakeInput = '187438238\n'

function interpret(filename) {
	const rom = fs.readFileSync(filename);
	if (rom === undefined) return
	const tab = Buffer.alloc(30000)
	let tabIndex = 0
	let fakeInputIndex = 0
	function handleLoop(romIndex) {
		let op = rom[romIndex] == '['.charCodeAt() ? 1 : -1
		for (let counter = 0;; romIndex += op) {
			if (rom[romIndex] == '['.charCodeAt())
				counter++
			else if (rom[romIndex] == ']'.charCodeAt())
				counter--
			if (counter == 0) break
		}
		return romIndex
	}
	for (let romIndex = 0; romIndex < rom.length; romIndex++) {
		switch (rom[romIndex]) {
		case '+'.charCodeAt():
			tab[tabIndex]++
			break
		case '-'.charCodeAt():
			tab[tabIndex]--
			break
		case '>'.charCodeAt():
			tabIndex++
			break
		case '<'.charCodeAt():
			tabIndex--
			break
		case '.'.charCodeAt():
			process.stdout.write(String.fromCharCode(tab[tabIndex]))
			break;
		case ','.charCodeAt():
			// Oopsie, impossible unless we use recursion. ^_^
			tab[tabIndex] = fakeInput.charCodeAt(fakeInputIndex++)
			break
		case '['.charCodeAt():
			if (tab[tabIndex] == 0)
				romIndex = handleLoop(romIndex)
			break
		case ']'.charCodeAt():
			if (tab[tabIndex] != 0)
				romIndex = handleLoop(romIndex)
			break
		}
	}
}

process.argv.slice(2).forEach(interpret)
