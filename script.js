// Initialisation des registres (x0 à x31)
const registers = Array(32).fill(0);
registers[0] = 0; // x0 reste toujours 0
//Initialisation des registres x0 à x31 avec les valeurs 0 à 31
for (let i = 0; i < 32; i++) {
    registers[i] = i;
}

// Initialisation de la mémoire (par exemple, 1024 octets)
const memory = new Uint8Array(1024); // Mémoire de 1024 octets pour la simulation

//initialise un premier mot en mémoire 0xFFAABBCC
storeWord(0, 0xFFAABBCC);
storeWord(4, 0x11223344);
storeWord(8, 0x55667788);

// Fonctions d'accès en mémoire
function loadByte(address) {
    return memory[address];
}

function loadHalfWord(address) {
    return (memory[address] | (memory[address + 1] << 8)) & 0xFFFF;
}

function loadWord(address) {
    return memory[address] | (memory[address + 1] << 8) | (memory[address + 2] << 16) | (memory[address + 3] << 24);
}

function storeByte(address, value) {
    memory[address] = value & 0xFF;
}

function storeHalfWord(address, value) {
    memory[address] = value & 0xFF;
    memory[address + 1] = (value >> 8) & 0xFF;
}

function storeWord(address, value) {
    memory[address] = value & 0xFF;
    memory[address + 1] = (value >> 8) & 0xFF;
    memory[address + 2] = (value >> 16) & 0xFF;
    memory[address + 3] = (value >> 24) & 0xFF;
}

// Fonction de décodage pour les instructions R-type
function decodeRType(instr) {
    const rd = (instr >> 7) & 0x1F;
    const funct3 = (instr >> 12) & 0x7;
    const rs1 = (instr >> 15) & 0x1F;
    const rs2 = (instr >> 20) & 0x1F;
    const funct7 = (instr >> 25) & 0x7F;
    return { type: 'R', rd, rs1, rs2, funct3, funct7 };
}

// Fonction de décodage pour les instructions I-type
function decodeIType(instr) {
    const rd = (instr >> 7) & 0x1F;
    const funct3 = (instr >> 12) & 0x7;
    const rs1 = (instr >> 15) & 0x1F;
    let imm = (instr >> 20) & 0xFFF;
    if (imm & 0x800) imm -= 0x1000; // Extension du signe pour les valeurs négatives
    return { type: 'I', rd, rs1, imm, funct3 };
}

// Décodeur S-type pour les instructions de STORE
function decodeSType(instr) {
    const imm = ((instr >> 7) & 0x1F) | ((instr >> 25) << 5);
    const rs1 = (instr >> 15) & 0x1F;
    const rs2 = (instr >> 20) & 0x1F;
    return { type: 'S', rs1, rs2, imm: imm >= 0x800 ? imm - 0x1000 : imm };
}

// Fonction d'exécution des instructions de type R et I
function executeInstruction(instr) {
    const opcode = instr & 0x7F;

    if (opcode === 0x03) { // I-type LOAD
        const { rd, rs1, imm, funct3 } = decodeIType(instr);
        const address = registers[rs1] + imm;

        switch (funct3) {
            case 0: // LB
                registers[rd] = (loadByte(address) << 24) >> 24; // Extension de signe
                return `lb x${rd}, ${imm}(x${rs1}) => x${rd} = ${registers[rd]}`;
            case 1: // LH
                registers[rd] = (loadHalfWord(address) << 16) >> 16; // Extension de signe
                return `lh x${rd}, ${imm}(x${rs1}) => x${rd} = ${registers[rd]}`;
            case 2: // LW
                registers[rd] = loadWord(address);
                return `lw x${rd}, ${imm}(x${rs1}) => x${rd} = ${registers[rd]}`;
            case 4: // LBU
                registers[rd] = loadByte(address);
                return `lbu x${rd}, ${imm}(x${rs1}) => x${rd} = ${registers[rd]}`;
            case 5: // LHU
                registers[rd] = loadHalfWord(address);
                return `lhu x${rd}, ${imm}(x${rs1}) => x${rd} = ${registers[rd]}`;
        }
    } else if (opcode === 0x23) { // S-type STORE
        const { rs1, rs2, imm } = decodeSType(instr);
        const address = registers[rs1] + imm;

        switch ((instr >> 12) & 0x7) {
            case 0: // SB
                storeByte(address, registers[rs2]);
                return `sb x${rs2}, ${imm}(x${rs1}) => Mem[${address}] = ${registers[rs2] & 0xFF}`;
            case 1: // SH
                storeHalfWord(address, registers[rs2]);
                return `sh x${rs2}, ${imm}(x${rs1}) => Mem[${address}] = ${registers[rs2] & 0xFFFF}`;
            case 2: // SW
                storeWord(address, registers[rs2]);
                return `sw x${rs2}, ${imm}(x${rs1}) => Mem[${address}] = ${registers[rs2]}`;
        }
    }

    else if (opcode === 0x33) { // R-type
        const { rd, rs1, rs2, funct3, funct7 } = decodeRType(instr);

        // Instructions R-type
        switch (funct3) {
            case 0:
                if (funct7 === 0x00) { // ADD
                    registers[rd] = registers[rs1] + registers[rs2];
                    return `add x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
                } else if (funct7 === 0x20) { // SUB
                    registers[rd] = registers[rs1] - registers[rs2];
                    return `sub x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
                }
                break;
            case 1: // SLL
                registers[rd] = registers[rs1] << (registers[rs2] & 0x1F);
                return `sll x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
            case 2: // SLT
                registers[rd] = registers[rs1] < registers[rs2] ? 1 : 0;
                return `slt x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
            case 3: // SLTU
                registers[rd] = (registers[rs1] >>> 0) < (registers[rs2] >>> 0) ? 1 : 0;
                return `sltu x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
            case 4: // XOR
                registers[rd] = registers[rs1] ^ registers[rs2];
                return `xor x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
            case 5:
                if (funct7 === 0x00) { // SRL
                    registers[rd] = (registers[rs1] >>> (registers[rs2] & 0x1F)) >>> 0;
                    return `srl x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
                } else if (funct7 === 0x20) { // SRA
                    registers[rd] = registers[rs1] >> (registers[rs2] & 0x1F);
                    return `sra x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
                }
                break;
            case 6: // OR
                registers[rd] = registers[rs1] | registers[rs2];
                return `or x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
            case 7: // AND
                registers[rd] = registers[rs1] & registers[rs2];
                return `and x${rd}, x${rs1}, x${rs2} => x${rd} = ${registers[rd]}`;
        }
    } else if (opcode === 0x13) { // I-type
        const { rd, rs1, imm, funct3 } = decodeIType(instr);

        // Instructions I-type
        switch (funct3) {
            case 0: // ADDI
                registers[rd] = registers[rs1] + imm;
                return `addi x${rd}, x${rs1}, ${imm} => x${rd} = ${registers[rd]}`;
            case 1: // SLLI
                registers[rd] = registers[rs1] << (imm & 0x1F);
                return `slli x${rd}, x${rs1}, ${imm & 0x1F} => x${rd} = ${registers[rd]}`;
            case 2: // SLTI
                registers[rd] = registers[rs1] < imm ? 1 : 0;
                return `slti x${rd}, x${rs1}, ${imm} => x${rd} = ${registers[rd]}`;
            case 3: // SLTIU
                registers[rd] = (registers[rs1] >>> 0) < (imm >>> 0) ? 1 : 0;
                return `sltiu x${rd}, x${rs1}, ${imm} => x${rd} = ${registers[rd]}`;
            case 4: // XORI
                registers[rd] = registers[rs1] ^ imm;
                return `xori x${rd}, x${rs1}, ${imm} => x${rd} = ${registers[rd]}`;
            case 5:
                if ((imm & 0xFE0) === 0) { // SRLI
                    registers[rd] = registers[rs1] >>> (imm & 0x1F);
                    return `srli x${rd}, x${rs1}, ${imm & 0x1F} => x${rd} = ${registers[rd]}`;
                } else if ((imm & 0xFE0) === 0x400) { // SRAI
                    registers[rd] = registers[rs1] >> (imm & 0x1F);
                    return `srai x${rd}, x${rs1}, ${imm & 0x1F} => x${rd} = ${registers[rd]}`;
                }
                break;
            case 6: // ORI
                registers[rd] = registers[rs1] | imm;
                return `ori x${rd}, x${rs1}, ${imm} => x${rd} = ${registers[rd]}`;
            case 7: // ANDI
                registers[rd] = registers[rs1] & imm;
                return `andi x${rd}, x${rs1}, ${imm} => x${rd} = ${registers[rd]}`;
        }
    }
    return `Instruction non supportée ou incomplète: ${instr.toString(16)}`;
}

function simulate() {
    const instructionsInput = document.getElementById('instruction-input').value.trim().split('\n');
    const outputElement = document.getElementById('output');
    outputElement.innerHTML = ''; // Efface la sortie précédente

    // Réinitialise les registres et la mémoire avant la simulation
    registers.fill(0);
    memory.fill(0);

    for (let i = 0; i < 32; i++) {
        registers[i] = i;
    }

    // Initialise un premier mot en mémoire 0xFFAABBCC
    storeWord(0, 0xFFAABBCC);
    storeWord(4, 0x11223344);
    storeWord(8, 0x55667788);

    instructionsInput.forEach((hexInstruction, index) => {
        const instr = parseInt(hexInstruction, 16); // Convertir hex en entier
        const result = executeInstruction(instr);

        // Création d'une ligne dans le tableau pour chaque instruction
        const row = document.createElement('tr');

        // Colonne Étape
        const stepCell = document.createElement('td');
        stepCell.textContent = index + 1;
        row.appendChild(stepCell);

        // Colonne Instruction
        const instrCell = document.createElement('td');
        instrCell.textContent = hexInstruction;
        row.appendChild(instrCell);

        // Colonne Résultat
        const resultCell = document.createElement('td');
        resultCell.textContent = result;
        row.appendChild(resultCell);

        outputElement.appendChild(row);
    });

    updateRegisterDisplay();
    updateMemoryDisplay(); // Affiche la mémoire après chaque simulation

    // Affiche le conteneur de sortie sur mobile après la simulation
    if (window.innerWidth <= 800) {
        document.getElementById('output-container').style.display = 'block';
        document.getElementById('instruction-container').style.display = 'none';
    }
}

// Fonction pour mettre à jour l'affichage des registres
function updateRegisterDisplay() {
    const registerBank = document.getElementById('register-bank');
    registerBank.innerHTML = ''; // Effacer les registres précédents

    registers.forEach((value, index) => {
        const registerDiv = document.createElement('div');
        registerDiv.textContent = `x${index} = ${value}`;
        registerBank.appendChild(registerDiv);
    });
}

function updateMemoryDisplay() {
    const memoryBank = document.getElementById('memory-bank');
    memoryBank.innerHTML = ''; // Efface l'affichage précédent de la mémoire

    for (let i = 0; i < memory.length; i++) {
        const memoryDiv = document.createElement('div');
        const hexValue = memory[i].toString(16).padStart(2, '0'); // Convertit en hexadécimal avec deux chiffres
        memoryDiv.textContent = `Mem[${i}] = 0x${hexValue}`;
        memoryBank.appendChild(memoryDiv);
    }
}









