import { parseHexInstruction } from './parser.js'; // Importation du parser depuis parser.js

// Initialisation de la mémoire et des registres
let memory = Array(32).fill(0); 
let registers = Array.from({ length: 32 }, (_, index) => index); // x0 = 0, x1 = 1, ..., x31 = 31

// Affichage de la banque de registres
function displayRegisters() {
    const registerBank = document.getElementById("register-bank");

    if (!registerBank) {
        console.error("L'élément 'register-bank' est introuvable dans le DOM.");
        return;
    }

    registerBank.innerHTML = ''; // Efface le contenu existant

    registers.forEach((value, index) => {
        // Affichage des registres x0, x1, ..., x31 avec leurs valeurs
        registerBank.innerHTML += `<div>x${index}: ${value}</div>`;
    });
}

// Affichage de la mémoire
function displayMemory() {
    const memoryBank = document.getElementById("memory-bank");

    if (!memoryBank) {
        console.error("L'élément 'memory-bank' est introuvable dans le DOM.");
        return;
    }

    memoryBank.innerHTML = ''; // Efface le contenu existant

    memory.forEach((value, index) => {
        memoryBank.innerHTML += `<div>Adresse ${index}: ${value}</div>`;
    });
}

// Traitement des instructions
function processInstructions() {
    const instructionsInput = document.getElementById("instructions-input").value;
    const instructions = instructionsInput.split('\n').map(line => line.trim()).filter(line => line);

    instructions.forEach(instructionHex => {
        const parsedInstruction = parseHexInstruction(instructionHex);
        if (parsedInstruction) {
            executeInstruction(parsedInstruction);
        } else {
            console.error("Instruction hexadécimale invalide :", instructionHex);
        }
    });

    // Mise à jour de l'affichage après le traitement
    displayRegisters();
    displayMemory();
}

// Exécution d'une instruction décodée
function executeInstruction(instruction) {
    const { type, rd, rs1, rs2 } = instruction;

    switch(type) {
        case 'ADD':
            registers[rd] = registers[rs1] + registers[rs2];
            break;
        case 'SUB':
            registers[rd] = registers[rs1] - registers[rs2];
            break;
        default:
            console.log("Type d'instruction non supporté :", type);
    }
}

// Affichage initial des registres et de la mémoire au chargement de la page
displayRegisters();
displayMemory();
