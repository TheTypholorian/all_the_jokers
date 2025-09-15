require(notbalatro and "src.misc_functions" or "misc_functions")
local Board = require(notbalatro and "src.board" or "board")
local Puyo = require(notbalatro and "src.puyo" or "puyo")

PuyoPuyo = {}

PuyoPuyo.colors = {
    background = HEX('2d433c'),
    mult = HEX('FE5F55'),
    dark_mult = HEX('cc4846'),
    chips = HEX('009cfd'),
    dark_chips = HEX('1685cb'),
    red = HEX('fd5f55'),
    blue = HEX('009cfd'),
    yellow = HEX('f2c255'),
    green = HEX('4bc292'),
    purple = HEX('8a71e1'),
    clear = HEX('ffe4a6'),
    edges = HEX('575763'),
    speedlevels = {
        [1] = HEX('ebf6f8'),
        [2] = HEX('c7d6d9'),
        [3] = HEX('FE5F55'),
        [4] = HEX('cc4846'),
        [5] = HEX('55a383'),
        [6] = HEX('4d8276'),
        [7] = HEX('4f6367'),
        [8] = HEX('445457'),
        [9] = HEX('009cfd'),
        [10] = HEX('1685cb'),
        [11] = HEX('8a71e1'),
        [12] = HEX('6059a0'),
        [13] = HEX('e47c4c'),
        [14] = HEX('a66040'),
        [15] = HEX('ffe4a6'),
        [16] = HEX('f2c255'),
        [17] = HEX('c09533')
    }
}

PuyoPuyo.speeds = {
    [1] = 1.0,
    [2] = 0.9385416667,
    [3] = 0.8770833333,
    [4] = 0.815625,
    [5] = 0.7541666667,
    [6] = 0.6927083333,
    [7] = 0.63125,
    [8] = 0.5697916667,
    [9] = 0.5083333333,
    [10] = 0.446875,
    [11] = 0.3854166667,
    [12] = 0.3239583333,
    [13] = 0.2625,
    [14] = 0.2010416667,
    [15] = 0.1395833333,
    [16] = 0.078125,
    [17] = 0.0166666667,
}

PuyoPuyo.inputBuffer = {}

PuyoPuyo.inputState = {
    left = {held = false, timer = 0},
    right = {held = false, timer = 0},
    down = {held = false, timer = 0},
    z = {held = false, timer = 0},
    x = {held = false, timer = 0},
    up = {held = false, timer = 0}, -- hard drop, only on press
}
PuyoPuyo.moveInitialDelay = 0.15
PuyoPuyo.moveRepeatDelay = 0.025

local keyMap = {
    left = "left",
    right = "right",
    down = "down",
    z = "z",
    x = "x",
    up = "up"
}

PuyoPuyo.directory = ''
PuyoPuyo.speedLevel = 1
PuyoPuyo.settling = false
PuyoPuyo.clearing = false
PuyoPuyo.hardDropping = false
PuyoPuyo.comboQueue = {}
PuyoPuyo.comboTimer = 0
PuyoPuyo.comboDelay = 0.4
PuyoPuyo.score = 0
PuyoPuyo.baseMultiplier = 1.0
PuyoPuyo.chainCount = 0

PuyoPuyo.lockDelay = 0.5
PuyoPuyo.lockTimer = 0
PuyoPuyo.lockDelayActive = false

PuyoPuyo.gameOver = false
PuyoPuyo.gameOverAnim = {
    active = false,
    currentRow = 0,
    timer = 0,
    delay = 0.08,
    fallSpeed = 120,
    rowsToFall = {},
    postFallPause = 0.25,
    postFallTimer = 0,
    puyosToDelete = {},
}

local puyo_colors = { "red", "blue", "yellow", "green", "purple" }
local puyo_variants = { "forward", "up", "down", "left", "right", "cleared" }

local BOARD_COLS = 6
local BOARD_ROWS = 12

local CLEAR_BLINKS = 3
local CLEAR_BLINK_INTERVAL = 0.08
local CLEAR_PAUSE = 0.18

local function random_color()
    return puyo_colors[love.math.random(1, #puyo_colors)]
end

local function gridToPixel(col, row)
    local x = PuyoPuyo.board.x + (col - 1) * Puyo.SIZE + 1
    local y = PuyoPuyo.board.y + (row - 1) * Puyo.SIZE + 1
    return x, y
end

local function updatePuyoPosition(puyo, dt, speed)
    local tx, ty = puyo.targetX or puyo.x, puyo.targetY or puyo.y
    local dx, dy = tx - puyo.x, ty - puyo.y
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist < 0.5 then
        puyo.x, puyo.y = tx, ty
        return true
    else
        local moveDist = math.min(dist, speed * dt)
        if dist > 0 then
            puyo.x = puyo.x + dx / dist * moveDist
            puyo.y = puyo.y + dy / dist * moveDist
        end
        return false
    end
end

function PuyoPuyo.load()
    PuyoPuyo.cardTexture = love.graphics.newImage(PuyoPuyo.directory.."assets/card.png")
    PuyoPuyo.overlayTexture = love.graphics.newImage(PuyoPuyo.directory.."assets/overlay.png")

    PuyoPuyo.board = Board.new(14, 0, 32, 62)

    PuyoPuyo.puyoSheet = love.graphics.newImage(PuyoPuyo.directory.."assets/puyos.png")
    local puyo_sheet = {
        colors = puyo_colors,
        variants = puyo_variants
    }
    PuyoPuyo.puyoQuads = {}
    for i, v in ipairs(puyo_sheet.colors) do
        PuyoPuyo.puyoQuads[v] = {}
        for _i, _v in ipairs(puyo_sheet.variants) do
            PuyoPuyo.puyoQuads[v][_v] = love.graphics.newQuad((_i-1)*5, (i-1)*5, 5, 5, PuyoPuyo.puyoSheet:getDimensions())
        end
    end

    PuyoPuyo.guidePuyoSheet = love.graphics.newImage(PuyoPuyo.directory.."assets/guidePuyos.png")
    PuyoPuyo.guidePuyoQuads = {}
    for i, v in ipairs(puyo_colors) do
        PuyoPuyo.guidePuyoQuads[v] = love.graphics.newQuad(0, (i-1)*5, 5, 5, PuyoPuyo.guidePuyoSheet:getDimensions())
    end

    PuyoPuyo.fallingPuyoPair = nil
    PuyoPuyo.fallingPairRotation = 0

    PuyoPuyo.lockedPuyos = {}
    for row = 1, BOARD_ROWS do
        PuyoPuyo.lockedPuyos[row] = {}
        for col = 1, BOARD_COLS do
            PuyoPuyo.lockedPuyos[row][col] = nil
        end
    end

    PuyoPuyo.moveRepeatDelay = 0.12
    PuyoPuyo.moveRepeatTimer = 0
    PuyoPuyo.moveHeld = nil

    PuyoPuyo.gravityInterval = 0.5
    PuyoPuyo.gravityTimer = 0

    if not PuyoPuyo.queue then
        PuyoPuyo.queue = {}
    end
end

local function floodFill(row, col, color, visited)
    local stack = {{row, col}}
    local group = {}
    while #stack > 0 do
        local pos = table.remove(stack)
        local r, c = pos[1], pos[2]
        if r >= 1 and r <= BOARD_ROWS and c >= 1 and c <= BOARD_COLS and not visited[r][c] then
            local puyo = PuyoPuyo.lockedPuyos[r][c]
            if puyo and puyo.color == color then
                visited[r][c] = true
                table.insert(group, {row = r, col = c, puyo = puyo})
                table.insert(stack, {r-1, c})
                table.insert(stack, {r+1, c})
                table.insert(stack, {r, c-1})
                table.insert(stack, {r, c+1})
            end
        end
    end
    return group
end

local function findAllClearGroups()
    local visited = {}
    for r = 1, BOARD_ROWS do
        visited[r] = {}
    end
    local groups = {}
    for row = 1, BOARD_ROWS do
        for col = 1, BOARD_COLS do
            local puyo = PuyoPuyo.lockedPuyos[row][col]
            if puyo and not visited[row][col] then
                local group = floodFill(row, col, puyo.color, visited)
                if #group >= 4 then
                    table.insert(groups, group)
                end
            end
        end
    end
    return groups
end

local function queueClearGroups(groups)
    for _, group in ipairs(groups) do
        for _, cell in ipairs(group) do
            local puyo = cell.puyo
            puyo.toClear = true
            puyo.clearAnim = {
                blinkCount = 0,
                blinkTimer = 0,
                visible = true,
                phase = "blinking",
                pauseTimer = 0
            }
            puyo:setQuad(PuyoPuyo.puyoQuads[puyo.color].cleared)
        end
    end
    PuyoPuyo.comboQueue = groups
    PuyoPuyo.clearing = true
    PuyoPuyo.comboTimer = 0
end

local function clearMarkedPuyos()
    for row = 1, BOARD_ROWS do
        for col = 1, BOARD_COLS do
            local puyo = PuyoPuyo.lockedPuyos[row][col]
            if puyo and puyo.toClear and puyo.clearAnim and puyo.clearAnim.phase == "done" then
                PuyoPuyo.lockedPuyos[row][col] = nil
            end
        end
    end
end

local function updateClearingAnimations(dt)
    local allDone = true
    for row = 1, BOARD_ROWS do
        for col = 1, BOARD_COLS do
            local puyo = PuyoPuyo.lockedPuyos[row][col]
            if puyo and puyo.toClear and puyo.clearAnim then
                local anim = puyo.clearAnim
                if anim.phase == "blinking" then
                    anim.blinkTimer = anim.blinkTimer + dt
                    if anim.blinkTimer >= CLEAR_BLINK_INTERVAL then
                        anim.blinkTimer = anim.blinkTimer - CLEAR_BLINK_INTERVAL
                        anim.visible = not anim.visible
                        if not anim.visible then
                            anim.blinkCount = anim.blinkCount + 1
                            if anim.blinkCount >= CLEAR_BLINKS then
                                anim.phase = "pause"
                                anim.pauseTimer = 0
                                anim.visible = true
                            end
                        end
                    end
                    allDone = false
                elseif anim.phase == "pause" then
                    anim.pauseTimer = anim.pauseTimer + dt
                    if anim.pauseTimer >= CLEAR_PAUSE then
                        anim.phase = "done"
                    else
                        allDone = false
                    end
                end
            end
        end
    end
    return allDone
end

local function updateAllPuyoVariants()
    for row = 1, BOARD_ROWS do
        for col = 1, BOARD_COLS do
            local puyo = PuyoPuyo.lockedPuyos[row][col]
            if puyo and not puyo.toClear then
                local sameColor = {up=false, down=false, left=false, right=false}
                -- Up
                if row > 1 then
                    local n = PuyoPuyo.lockedPuyos[row-1][col]
                    if n and n.color == puyo.color and not n.toClear then sameColor.up = true end
                end
                -- Down
                if row < BOARD_ROWS then
                    local n = PuyoPuyo.lockedPuyos[row+1][col]
                    if n and n.color == puyo.color and not n.toClear then sameColor.down = true end
                end
                -- Left
                if col > 1 then
                    local n = PuyoPuyo.lockedPuyos[row][col-1]
                    if n and n.color == puyo.color and not n.toClear then sameColor.left = true end
                end
                -- Right
                if col < BOARD_COLS then
                    local n = PuyoPuyo.lockedPuyos[row][col+1]
                    if n and n.color == puyo.color and not n.toClear then sameColor.right = true end
                end

                local count = 0
                for _, v in pairs(sameColor) do if v then count = count + 1 end end
                if count > 1 then
                    puyo:setQuad(PuyoPuyo.puyoQuads[puyo.color].forward)
                elseif count == 1 then
                    if sameColor.up then
                        puyo:setQuad(PuyoPuyo.puyoQuads[puyo.color].up)
                    elseif sameColor.down then
                        puyo:setQuad(PuyoPuyo.puyoQuads[puyo.color].down)
                    elseif sameColor.left then
                        puyo:setQuad(PuyoPuyo.puyoQuads[puyo.color].left)
                    elseif sameColor.right then
                        puyo:setQuad(PuyoPuyo.puyoQuads[puyo.color].right)
                    end
                else
                    puyo:setQuad(PuyoPuyo.puyoQuads[puyo.color].forward)
                end
            end
        end
    end
end

local function updateComboLogic(dt)
    if PuyoPuyo.clearing then
        local allDone = updateClearingAnimations(dt)
        if allDone then
            local puyosCleared = 0
            for _, group in ipairs(PuyoPuyo.comboQueue) do
                puyosCleared = puyosCleared + #group
            end

            local multiplier = 1.0
            if puyosCleared > 4 then
                multiplier = 1.0 + 0.5 * math.floor(puyosCleared / 4)
            end
            multiplier = multiplier * PuyoPuyo.baseMultiplier

            PuyoPuyo.score = PuyoPuyo.score + math.floor(puyosCleared * multiplier)

            if PuyoPuyo.chainCount > 0 then
                PuyoPuyo.baseMultiplier = PuyoPuyo.baseMultiplier + 0.5
            end

            PuyoPuyo.chainCount = PuyoPuyo.chainCount + 1

            clearMarkedPuyos()
            updateAllPuyoVariants()
            PuyoPuyo.clearing = false
            PuyoPuyo.settling = true
            PuyoPuyo.queue[#PuyoPuyo.queue+1] = {type = 'score'}
        end
        return true
    elseif not PuyoPuyo.settling then
        local groups = findAllClearGroups()
        if #groups > 0 then
            queueClearGroups(groups)
            return true
        else
            PuyoPuyo.chainCount = 0
            PuyoPuyo.baseMultiplier = 1.0
        end
    end
    return false
end

local function isSpawnBlocked()
    local spawnCol = math.floor(BOARD_COLS / 2)
    local spawnRow = 1
    local positions = {
        {spawnCol, spawnRow},
        {spawnCol, spawnRow - 1}
    }
    for _, pos in ipairs(positions) do
        local col, row = pos[1], pos[2]
        if row >= 1 and row <= BOARD_ROWS and PuyoPuyo.lockedPuyos[row][col] ~= nil then
            return true
        end
    end
    return false
end

local function startGameOverAnim()
    PuyoPuyo.gameOverAnim.active = true
    PuyoPuyo.gameOverAnim.currentRow = BOARD_ROWS
    PuyoPuyo.gameOverAnim.timer = 0
    PuyoPuyo.gameOverAnim.rowsToFall = {}
    PuyoPuyo.gameOverAnim.puyosToDelete = {}
    PuyoPuyo.gameOverAnim.postFallTimer = 0
    PuyoPuyo.gameOverAnim.finishedRows = false
    for row = 1, BOARD_ROWS do
        PuyoPuyo.gameOverAnim.rowsToFall[row] = false
    end
end

local function updateGameOverAnim(dt)
    local anim = PuyoPuyo.gameOverAnim
    if not anim.active then return end

    if not anim.finishedRows then
        anim.timer = anim.timer + dt
        while anim.currentRow >= 1 and anim.timer >= anim.delay do
            anim.timer = anim.timer - anim.delay
            anim.rowsToFall[anim.currentRow] = true
            anim.currentRow = anim.currentRow - 1
        end

        for row = 1, BOARD_ROWS do
            if anim.rowsToFall[row] then
                for col = 1, BOARD_COLS do
                    local puyo = PuyoPuyo.lockedPuyos[row][col]
                    if puyo then
                        puyo.y = puyo.y + anim.fallSpeed * dt
                        if puyo.y > PuyoPuyo.board.y + BOARD_ROWS * Puyo.SIZE + 2 then
                            table.insert(anim.puyosToDelete, {row = row, col = col})
                        end
                    end
                end
            end
        end

        for _, cell in ipairs(anim.puyosToDelete) do
            PuyoPuyo.lockedPuyos[cell.row][cell.col] = nil
        end
        anim.puyosToDelete = {}

        local anyLeft = false
        for row = 1, BOARD_ROWS do
            for col = 1, BOARD_COLS do
                if PuyoPuyo.lockedPuyos[row][col] then
                    anyLeft = true
                end
            end
        end
        if anim.currentRow < 1 and not anyLeft then
            anim.finishedRows = true
            anim.postFallTimer = 0
        end
    else
        anim.postFallTimer = anim.postFallTimer + dt
        if anim.postFallTimer >= anim.postFallPause then
            anim.active = false
            PuyoPuyo.gameOver = false
            PuyoPuyo.baseMultiplier = 1.0
            PuyoPuyo.chainCount = 0
            for row = 1, BOARD_ROWS do
                for col = 1, BOARD_COLS do
                    PuyoPuyo.lockedPuyos[row][col] = nil
                end
            end
            PuyoPuyo.settling = false
            PuyoPuyo.clearing = false
            PuyoPuyo.hardDropping = false
            PuyoPuyo.fallingPuyoPair = nil
            PuyoPuyo.inputBuffer = {}
            for k, v in pairs(PuyoPuyo.inputState) do
                v.held = false
                v.timer = 0
            end
        end
    end
end

function PuyoPuyo.spawnPuyoPair()
    if PuyoPuyo.fallingPuyoPair or PuyoPuyo.gameOver or PuyoPuyo.gameOverAnim.active then return end

    if isSpawnBlocked() then
        PuyoPuyo.queue[#PuyoPuyo.queue+1] = {type = 'reset'}
        PuyoPuyo.speedLevel = 1
        PuyoPuyo.score = 0
        PuyoPuyo.gameOver = true
        startGameOverAnim()
        return
    end

    local spawnCol = math.floor(BOARD_COLS / 2)
    local spawnRow = 1

    local color1 = random_color()
    local color2 = random_color()

    local puyo1 = Puyo.new(0, 0, PuyoPuyo.puyoQuads[color1].forward, PuyoPuyo.puyoSheet)
    local puyo2 = Puyo.new(0, 0, PuyoPuyo.puyoQuads[color2].forward, PuyoPuyo.puyoSheet)
    puyo1.color = color1
    puyo2.color = color2

    puyo1.gridCol, puyo1.gridRow = spawnCol, spawnRow
    puyo2.gridCol, puyo2.gridRow = spawnCol, spawnRow - 1

    puyo1.x, puyo1.y = gridToPixel(puyo1.gridCol, puyo1.gridRow)
    puyo2.x, puyo2.y = gridToPixel(puyo2.gridCol, puyo2.gridRow)
    puyo1.targetX, puyo1.targetY = puyo1.x, puyo1.y
    puyo2.targetX, puyo2.targetY = puyo2.x, puyo2.y

    PuyoPuyo.fallingPuyoPair = { puyo1, puyo2 }
    PuyoPuyo.fallingPairRotation = 0 -- up
end

local function willCollide(col, row)
    if row > BOARD_ROWS then return true end
    if col < 1 or col > BOARD_COLS then return true end
    if row >= 1 and PuyoPuyo.lockedPuyos[row][col] ~= nil then return true end
    return false
end

local function lockPuyo(puyo)
    local col, row = puyo.gridCol, puyo.gridRow
    -- Clamp to board
    if row < 1 then row = 1 end
    if row > BOARD_ROWS then row = BOARD_ROWS end
    if col < 1 then col = 1 end
    if col > BOARD_COLS then col = BOARD_COLS end
    puyo.gridCol, puyo.gridRow = col, row
    puyo.targetX, puyo.targetY = gridToPixel(col, row)
    PuyoPuyo.lockedPuyos[row][col] = puyo
end

local function getPairGridPositions(centerCol, centerRow, rotation)
    local offsets = {
        [0] = {0, -1}, -- up
        [1] = {1, 0},  -- right
        [2] = {0, 1},  -- down
        [3] = {-1, 0}, -- left
    }
    local dx, dy = unpack(offsets[rotation % 4])
    return {
        {centerCol, centerRow},           -- puyo1 (center)
        {centerCol + dx, centerRow + dy}  -- puyo2 (satellite)
    }
end

local function canPlacePair(positions)
    for i = 1, 2 do
        local col, row = positions[i][1], positions[i][2]
        if col < 1 or col > BOARD_COLS then
            return false
        end
        if row >= 1 and row <= BOARD_ROWS and PuyoPuyo.lockedPuyos[row][col] ~= nil then
            return false
        end
        if row > BOARD_ROWS then
            return false
        end
    end
    return true
end

local function isPairGrounded()
    if not PuyoPuyo.fallingPuyoPair then return false end
    local pair = PuyoPuyo.fallingPuyoPair
    local rotation = PuyoPuyo.fallingPairRotation
    local positions = getPairGridPositions(pair[1].gridCol, pair[1].gridRow, rotation)
    for i = 1, 2 do
        local col, row = positions[i][1], positions[i][2]
        local belowRow = row + 1
        if belowRow > BOARD_ROWS or (belowRow >= 1 and PuyoPuyo.lockedPuyos[belowRow][col]) then
            return true
        end
    end
    return false
end

local function tryMovePair(dx, dy)
    if not PuyoPuyo.fallingPuyoPair then return end
    local pair = PuyoPuyo.fallingPuyoPair
    local rotation = PuyoPuyo.fallingPairRotation

    local centerCol, centerRow = pair[1].gridCol, pair[1].gridRow
    local newCenterCol, newCenterRow = centerCol + dx, centerRow + dy

    local newPositions = getPairGridPositions(newCenterCol, newCenterRow, rotation)
    if canPlacePair(newPositions) then
        for i = 1, 2 do
            local col, row = newPositions[i][1], newPositions[i][2]
            pair[i].gridCol, pair[i].gridRow = col, row
            pair[i].targetX, pair[i].targetY = gridToPixel(col, row)
        end
        return true
    end
    return false
end

local function tryRotatePair(dir)
    if not PuyoPuyo.fallingPuyoPair then return end
    local pair = PuyoPuyo.fallingPuyoPair
    local oldRotation = PuyoPuyo.fallingPairRotation
    local newRotation = (oldRotation + dir) % 4

    local centerCol, centerRow = pair[1].gridCol, pair[1].gridRow
    local newPositions = getPairGridPositions(centerCol, centerRow, newRotation)

    if not canPlacePair(newPositions) then
        -- Try left
        newPositions = getPairGridPositions(centerCol - 1, centerRow, newRotation)
        if canPlacePair(newPositions) then
            centerCol = centerCol - 1
        else
            -- Try right
            newPositions = getPairGridPositions(centerCol + 1, centerRow, newRotation)
            if canPlacePair(newPositions) then
                centerCol = centerCol + 1
            else
                -- Try up (wall kick upwards)
                newPositions = getPairGridPositions(centerCol, centerRow - 1, newRotation)
                if canPlacePair(newPositions) then
                    centerRow = centerRow - 1
                else
                    return false -- Can't rotate
                end
            end
        end
    end

    newPositions = getPairGridPositions(centerCol, centerRow, newRotation)
    for i = 1, 2 do
        local col, row = newPositions[i][1], newPositions[i][2]
        pair[i].gridCol, pair[i].gridRow = col, row
        pair[i].targetX, pair[i].targetY = gridToPixel(col, row)
    end
    PuyoPuyo.fallingPairRotation = newRotation
    return true
end

local function tryMovePairWithLockReset(dx, dy)
    local moved = tryMovePair(dx, dy)
    if moved and isPairGrounded() then
        PuyoPuyo.lockTimer = 0
        PuyoPuyo.lockDelayActive = true
    end
    return moved
end

local function tryRotatePairWithLockReset(dir)
    local rotated = tryRotatePair(dir)
    if rotated and isPairGrounded() then
        PuyoPuyo.lockTimer = 0
        PuyoPuyo.lockDelayActive = true
    end
    return rotated
end

local function canPuyoFall(col, row)
    if row >= BOARD_ROWS then return false end
    if col < 1 or col > BOARD_COLS then return false end
    if PuyoPuyo.lockedPuyos[row][col] == nil then return false end
    if row + 1 > BOARD_ROWS then return false end
    return PuyoPuyo.lockedPuyos[row + 1][col] == nil
end

local function applyGravityToLockedPuyos(dt)
    local moved = false
    local settleSpeed = 120

    for row = BOARD_ROWS - 1, 1, -1 do
        for col = 1, BOARD_COLS do
            local puyo = PuyoPuyo.lockedPuyos[row][col]
            if puyo then
                local destRow = row
                for testRow = row + 1, BOARD_ROWS do
                    if PuyoPuyo.lockedPuyos[testRow][col] == nil then
                        destRow = testRow
                    else
                        break
                    end
                end
                if destRow ~= row then
                    PuyoPuyo.lockedPuyos[row][col] = nil
                    PuyoPuyo.lockedPuyos[destRow][col] = puyo
                    puyo.gridRow = destRow
                    puyo.targetX, puyo.targetY = gridToPixel(col, destRow)
                    moved = true
                end
            end
        end
    end

    for row = 1, BOARD_ROWS do
        for col = 1, BOARD_COLS do
            local puyo = PuyoPuyo.lockedPuyos[row][col]
            if puyo then
                updatePuyoPosition(puyo, dt, settleSpeed)
            end
        end
    end

    return moved
end

local function updateSpeedLevel()
    local maxLevel = 17
    while PuyoPuyo.speedLevel < maxLevel and PuyoPuyo.score >= (PuyoPuyo.speedLevel * 32 + 4) do
        PuyoPuyo.speedLevel = PuyoPuyo.speedLevel + 1
    end
    PuyoPuyo.gravityInterval = PuyoPuyo.speeds[PuyoPuyo.speedLevel]
end

local function bufferInput(action)
    table.insert(PuyoPuyo.inputBuffer, action)
end

function PuyoPuyo.update(dt)
    if PuyoPuyo.gameOverAnim.active then
        updateGameOverAnim(dt)
        return
    end
    if updateComboLogic(dt) then
        return
    end

    updateSpeedLevel()

    if PuyoPuyo.fallingPuyoPair and not PuyoPuyo.hardDropping and not PuyoPuyo.settling then
        for key, state in pairs(PuyoPuyo.inputState) do
            if state.held and key ~= "up" then
                state.timer = state.timer + dt
                local initialDelay = PuyoPuyo.moveInitialDelay
                local repeatDelay = PuyoPuyo.moveRepeatDelay
                local trigger = false

                if state.timer == dt then
                elseif state.timer >= initialDelay then
                    local repeats = math.floor((state.timer - initialDelay) / repeatDelay)
                    if repeats > 0 then
                        state.timer = initialDelay + (state.timer - initialDelay) % repeatDelay
                        trigger = true
                    end
                end

                if trigger then
                    if key == "left" then
                        tryMovePairWithLockReset(-1, 0)
                    elseif key == "right" then
                        tryMovePairWithLockReset(1, 0)
                    elseif key == "down" then
                        tryMovePairWithLockReset(0, 1)
                    elseif key == "z" then
                        tryRotatePairWithLockReset(-1)
                    elseif key == "x" then
                        tryRotatePairWithLockReset(1)
                    end
                end
            end
        end
    end

    if PuyoPuyo.settling then
        local anyMoved = applyGravityToLockedPuyos(dt)
        local allSettled = true
        for row = 1, BOARD_ROWS do
            for col = 1, BOARD_COLS do
                local puyo = PuyoPuyo.lockedPuyos[row][col]
                if puyo and ((math.abs((puyo.x or 0) - (puyo.targetX or 0)) > 0.5) or (math.abs((puyo.y or 0) - (puyo.targetY or 0)) > 0.5)) then
                    allSettled = false
                end
            end
        end
        if allSettled and not anyMoved then
            updateAllPuyoVariants()
            PuyoPuyo.settling = false
        end
        return
    end

    if PuyoPuyo.hardDropping and PuyoPuyo.fallingPuyoPair then
        local settleSpeed = 480
        local pair = PuyoPuyo.fallingPuyoPair
        local allAtTarget = true
        for _, puyo in ipairs(pair) do
            if not updatePuyoPosition(puyo, dt, settleSpeed) then
                allAtTarget = false
            end
        end
        if allAtTarget then
            for i = 1, 2 do
                lockPuyo(pair[i])
            end
            PuyoPuyo.fallingPuyoPair = nil
            PuyoPuyo.hardDropping = false
            PuyoPuyo.settling = true
        end
        return
    end

    if not PuyoPuyo.fallingPuyoPair then
        PuyoPuyo.spawnPuyoPair()
    end

    if PuyoPuyo.fallingPuyoPair and not PuyoPuyo.hardDropping and not PuyoPuyo.settling then
        local fallSpeed = 120
        local pair = PuyoPuyo.fallingPuyoPair
        for _, puyo in ipairs(pair) do
            updatePuyoPosition(puyo, dt, fallSpeed)
        end

        local bothAtTarget = true
        for _, puyo in ipairs(pair) do
            if (math.abs((puyo.x or 0) - (puyo.targetX or 0)) > 0.5) or (math.abs((puyo.y or 0) - (puyo.targetY or 0)) > 0.5) then
                bothAtTarget = false
            end
        end

        if bothAtTarget and #PuyoPuyo.inputBuffer > 0 then
            local action = table.remove(PuyoPuyo.inputBuffer, 1)
            if action == "left" then
                tryMovePairWithLockReset(-1, 0)
            elseif action == "right" then
                tryMovePairWithLockReset(1, 0)
            elseif action == "down" then
                tryMovePairWithLockReset(0, 1)
            elseif action == "z" then
                tryRotatePairWithLockReset(-1)
            elseif action == "x" then
                tryRotatePairWithLockReset(1)
            end
        end

        if bothAtTarget then
            if isPairGrounded() then
                if not PuyoPuyo.lockDelayActive then
                    PuyoPuyo.lockTimer = 0
                    PuyoPuyo.lockDelayActive = true
                end
                PuyoPuyo.lockTimer = PuyoPuyo.lockTimer + dt
                if PuyoPuyo.lockTimer >= PuyoPuyo.lockDelay then
                    for i = 1, 2 do
                        lockPuyo(pair[i])
                    end
                    PuyoPuyo.fallingPuyoPair = nil
                    PuyoPuyo.settling = true
                    PuyoPuyo.lockDelayActive = false
                    PuyoPuyo.lockTimer = 0
                    return
                end
            else
                PuyoPuyo.lockDelayActive = false
                PuyoPuyo.lockTimer = 0
            end

            PuyoPuyo.gravityTimer = PuyoPuyo.gravityTimer + dt
            if PuyoPuyo.gravityTimer >= PuyoPuyo.gravityInterval then
                PuyoPuyo.gravityTimer = PuyoPuyo.gravityTimer - PuyoPuyo.gravityInterval

                local moved = tryMovePair(0, 1)
            end
        end
    end
end

local SCORE_BOARD_X = 4
local SCORE_BOARD_Y = 10
local SCORE_BOARD_WIDTH = 6
local SCORE_BOARD_HEIGHT = 50
local SCORE_CUBE_SIZE = 2

local function drawScoreBoard(score, x_offset, y_offset)
    local cubesToFill = math.floor(score / 4)
    local cols = math.floor(SCORE_BOARD_WIDTH / SCORE_CUBE_SIZE)
    local rows = math.floor(SCORE_BOARD_HEIGHT / SCORE_CUBE_SIZE)

    local filled = 0
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            if filled < cubesToFill then
                local x = SCORE_BOARD_X + col * SCORE_CUBE_SIZE
                local y = SCORE_BOARD_Y + (rows - 1 - row) * SCORE_CUBE_SIZE
                if (col + row) % 2 == 0 then
                    love.graphics.setColor(PuyoPuyo.colors.chips)
                else
                    love.graphics.setColor(PuyoPuyo.colors.dark_chips)
                end
                love.graphics.rectangle("fill", x + x_offset, y + y_offset, SCORE_CUBE_SIZE, SCORE_CUBE_SIZE)
                filled = filled + 1
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

local SPEED_BOARD_X = 51
local SPEED_BOARD_Y = 9
local SPEED_BOARD_WIDTH = 3
local SPEED_BOARD_HEIGHT = 51
local SPEED_CUBE_SIZE = 3

local function drawSpeedBoard(speedLevel, x_offset, y_offset)
    local cols = math.floor(SPEED_BOARD_WIDTH / SPEED_CUBE_SIZE)
    local rows = math.floor(SPEED_BOARD_HEIGHT / SPEED_CUBE_SIZE)

    for i = 1, speedLevel do
        local row = i - 1
        local x = SPEED_BOARD_X
        local y = SPEED_BOARD_Y + SPEED_BOARD_HEIGHT - SPEED_CUBE_SIZE * (row + 1)
        local color = PuyoPuyo.colors.speedlevels[i] or {1, 1, 1, 1}
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x + x_offset, y + y_offset, SPEED_CUBE_SIZE, SPEED_CUBE_SIZE)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

local function getPairDropPositions(pair, rotation)
    local centerCol, centerRow = pair[1].gridCol, pair[1].gridRow
    local positions = getPairGridPositions(centerCol, centerRow, rotation)
    local col1, row1 = positions[1][1], positions[1][2]
    local col2, row2 = positions[2][1], positions[2][2]

    while true do
        local canDrop = true
        for _, pos in ipairs({{col1, row1+1}, {col2, row2+1}}) do
            local col, row = pos[1], pos[2]
            if row > BOARD_ROWS or (row >= 1 and PuyoPuyo.lockedPuyos[row][col]) then
                canDrop = false
                break
            end
        end
        if canDrop then
            row1 = row1 + 1
            row2 = row2 + 1
        else
            break
        end
    end
    return {
        {col1, row1},
        {col2, row2}
    }
end

local function drawGuidePuyos(x_offset, y_offset)
    if not PuyoPuyo.fallingPuyoPair then return end
    local pair = PuyoPuyo.fallingPuyoPair
    local rotation = PuyoPuyo.fallingPairRotation
    local dropPositions = getPairDropPositions(pair, rotation)
    local idxs = {1, 2}
    if dropPositions[2][2] < dropPositions[1][2] or (dropPositions[2][2] == dropPositions[1][2] and dropPositions[2][1] < dropPositions[1][1]) then
        idxs = {2, 1}
    end
    for _, i in ipairs(idxs) do
        local col, row = dropPositions[i][1], dropPositions[i][2]
        local color = pair[i].color
        local quad = PuyoPuyo.guidePuyoQuads[color]
        local x, y = gridToPixel(col, row)
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.draw(PuyoPuyo.guidePuyoSheet, quad, x + x_offset, y + y_offset)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

local function hardDropPair()
    if not PuyoPuyo.fallingPuyoPair then return end
    local pair = PuyoPuyo.fallingPuyoPair
    local rotation = PuyoPuyo.fallingPairRotation
    local dropPositions = getPairDropPositions(pair, rotation)
    for i = 1, 2 do
        local col, row = dropPositions[i][1], dropPositions[i][2]
        pair[i].gridCol, pair[i].gridRow = col, row
        pair[i].targetX, pair[i].targetY = gridToPixel(col, row)
    end
    PuyoPuyo.hardDropping = true
end

function PuyoPuyo.draw(x_offset, y_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0

    love.graphics.clear(0, 0, 0, 0)

    if PuyoPuyo.cardTexture then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(PuyoPuyo.cardTexture, 0, 0)
    end

    for row = 1, BOARD_ROWS do
        for col = 1, BOARD_COLS do
            local puyo = PuyoPuyo.lockedPuyos[row][col]
            if puyo then
                if puyo.toClear and puyo.clearAnim then
                    if puyo.clearAnim.visible then
                        puyo:draw(x_offset, y_offset)
                    end
                else
                    puyo:draw(x_offset, y_offset)
                end
            end
        end
    end

    -- Draw guide puyos before falling pair
    drawGuidePuyos(x_offset, y_offset)

    -- Drawing falling puyos
    if PuyoPuyo.fallingPuyoPair then
        for _, puyo in ipairs(PuyoPuyo.fallingPuyoPair) do
            puyo:draw(x_offset, y_offset)
        end
    end

    PuyoPuyo.board:draw(x_offset, y_offset)

    drawScoreBoard(PuyoPuyo.score, x_offset, y_offset)

    drawSpeedBoard(PuyoPuyo.speedLevel, x_offset, y_offset)

    if PuyoPuyo.overlayTexture then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(PuyoPuyo.overlayTexture, x_offset, y_offset-4)
    end
end

function PuyoPuyo.keypressed(key)
    if not PuyoPuyo.fallingPuyoPair then return end
    local mapped = keyMap[key]
    if not mapped then return end

    if mapped == "up" then
        if not PuyoPuyo.inputState.up.held then
            hardDropPair()
        end
        PuyoPuyo.inputState.up.held = true
        return
    end

    local pair = PuyoPuyo.fallingPuyoPair
    local animating = false
    for _, puyo in ipairs(pair) do
        if (math.abs((puyo.x or 0) - (puyo.targetX or 0)) > 0.5) or (math.abs((puyo.y or 0) - (puyo.targetY or 0)) > 0.5) then
            animating = true
            break
        end
    end

    if animating then
        bufferInput(mapped)
    else
        if mapped == "left" then
            tryMovePairWithLockReset(-1, 0)
        elseif mapped == "right" then
            tryMovePairWithLockReset(1, 0)
        elseif mapped == "down" then
            tryMovePairWithLockReset(0, 1)
        elseif mapped == "z" then
            tryRotatePairWithLockReset(-1)
        elseif mapped == "x" then
            tryRotatePairWithLockReset(1)
        end
    end

    local state = PuyoPuyo.inputState[mapped]
    state.held = true
    state.timer = 0
end

function PuyoPuyo.keyreleased(key)
    local mapped = keyMap[key]
    if mapped and PuyoPuyo.inputState[mapped] then
        PuyoPuyo.inputState[mapped].held = false
        PuyoPuyo.inputState[mapped].timer = 0
    end
end

function PuyoPuyo:controller_press_update(button, dt)
    if button == "dpup" then
        hardDropPair()
    end
    if button == "dpdown" then
        tryMovePairWithLockReset(0, 1)
    end
    if button == "dpleft" then
        tryMovePairWithLockReset(-1, 0)
    end
    if button == "dpright" then
        tryMovePairWithLockReset(1, 0)
    end
    if button == "rightstick" then
        tryRotatePairWithLockReset(-1)
    elseif button == 'leftstick' then
        tryRotatePairWithLockReset(1)
    end
end

function PuyoPuyo.getAdjacentLockedPuyos(col, row)
    local adj = {}
    local dirs = {
        {0, -1}, -- up
        {0, 1},  -- down
        {-1, 0}, -- left
        {1, 0},  -- right
    }
    for _, d in ipairs(dirs) do
        local ncol, nrow = col + d[1], row + d[2]
        if ncol >= 1 and ncol <= BOARD_COLS and nrow >= 1 and nrow <= BOARD_ROWS then
            local neighbor = PuyoPuyo.lockedPuyos[nrow][ncol]
            if neighbor then
                table.insert(adj, neighbor)
            end
        end
    end
    return adj
end

return PuyoPuyo