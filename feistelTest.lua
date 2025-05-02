--[[
Toy-Feistel-Cipher-in-Lua
MIT License (c) 2025 Cleary Bettisworth
https://github.com/half-cab/Toy-Feistel-Cipher-in-Lua
]]

-- feistelTest.lua
-- Created by Cleary Bettisworth
-- Suite to test the efficiency and performance of the cipher in 'feistel.lua'
-- Results are returned in the file 'test_results.txt'

local feistel = require("feistel")

local output = io.open("test_results.txt", "w")

local function log(...)
    local args = {...}
    for i = 1, #args do
        output:write(tostring(args[i]))
        if i < #args then output:write("\t") end
    end
    output:write("\n")
end

local function timeEncrypt(input, key, rounds, blockSize)
    local start = os.clock()
    local ciphertext = feistel.encrypt(input, key, rounds, blockSize)
    local elapsed = os.clock() - start
    return elapsed, ciphertext
end

local function byteFrequency(text)
    local freq = {}
    for i = 1, #text do
        local b = string.byte(text, i)
        freq[b] = (freq[b] or 0) + 1
    end
    return freq
end

local function logHistogramRow(inputSize, blockSize, rounds, time, byte, freq)
    log(inputSize, blockSize, rounds, string.format("%.5f", time), byte, freq)
end

log("inputSize", "blockSize", "rounds", "time", "byte", "frequency")

local testInputs = {
    "Short",
    "This is a medium length input string.",
    string.rep("A", 1024),
    string.rep("B", 4096),
    string.rep("C", 8192)
}

local blockSizes = {2, 4, 8, 16}
local roundsList = {2, 4, 8, 16, 32, 64}

for _, input in ipairs(testInputs) do
    for _, blockSize in ipairs(blockSizes) do
        for _, rounds in ipairs(roundsList) do
            local key = feistel.genRandKey(blockSize * rounds)
            local time, ciphertext = timeEncrypt(input, key, rounds, blockSize)

            -- Byte Frequency Analysis with spreadsheet format
            local freq = byteFrequency(ciphertext)
            for byte = 0, 255 do
                if freq[byte] then
                    logHistogramRow(#input, blockSize, rounds, time, byte, freq[byte])
                end
            end
        end
    end
end

log()
log("=== Decryption Validation ===")
local original = "Verify that decryption restores the original input correctly."
local key2 = feistel.genRandKey(64)
local enc = feistel.encrypt(original, key2, 8, 8)
local dec = feistel.decrypt(enc, key2, 8, 8)
log("Success:", original == dec)

output:close()