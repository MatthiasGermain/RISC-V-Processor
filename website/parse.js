// Function to parse a hexadecimal instruction
function parseHexInstruction(instructionHex) {
    if (!/^[0-9a-fA-F]+$/.test(instructionHex) || instructionHex.length > 8) {
        console.error("Invalid instruction format:", instructionHex);
        return null;
    }

    // Convert hex to binary (32 bits)
    const binary = parseInt(instructionHex, 16).toString(2).padStart(32, '0');

    // Extract opcode, rd, rs1, rs2 based on RISC-V encoding
    const opcode = binary.slice(25, 32);       // Last 7 bits
    const rd = parseInt(binary.slice(20, 25), 2); // Bits 20-24
    const funct3 = binary.slice(17, 20);       // Bits 17-19
    const rs1 = parseInt(binary.slice(12, 17), 2); // Bits 12-16
    const rs2 = parseInt(binary.slice(7, 12), 2);  // Bits 7-11
    const funct7 = binary.slice(0, 7);         // First 7 bits

    // Example for ADD and SUB (opcode for both is 0110011)
    if (opcode === '0110011') {
        if (funct3 === '000') {
            return {
                type: funct7 === '0000000' ? 'ADD' : funct7 === '0100000' ? 'SUB' : null,
                rd, rs1, rs2
            };
        }
    }

    // Return null for unsupported instruction type for simplicity
    return null;
}

// Export the parse function for use in main.js
export { parseHexInstruction };