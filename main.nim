import tables, math, random
import raylib

const
    WIDTH = 640
    HEIGHT = 480

const
    # algaeRule = {"A": "AB", "B": "A"}.toTable

    fractalPlantRule = {"X": "F+[[X]-X]-F[-FX]+X", "F": "FF"}.toTable

    bushRule = {"F": "FF+[+F-F-F]-[-F+F+F]"}.toTable

    # cactusRule = {"X": "X[-[[X]-[-FX]]][+[[X]-[+FX]]]FX", "F": "FF"}.toTable
    cactusRule = {"X": "F[+X[-F]][-X[+F]]FF", "F": "XF"}.toTable

func generate(axiom: string, rule: Table[string, string]): string =
    for c in axiom:
        if rule.hasKey($c):
            result.add(rule[$c])
        else:
            result.add(c)

func generation(axiom: string, rule: Table[string, string], n: int): string =
    result = axiom
    for i in 0 ..< n:
        result = generate(result, rule)

func visualiseFractalPlant(axiom: string) =
    const
        lineLen = 2
        lineThickness = 2.0
        branchAngle = degToRad(25.0)
        branchColor = White
        leafColor = Green
    var
        stack: seq[tuple[x, y, a: float]]
        currentX = WIDTH / 2
        currentY = HEIGHT.float
        currentAngle = 0.0

    for c in axiom:
        case c
        of 'F': #forward
            drawLine(
                Vector2(x: currentX, y: currentY),
                Vector2(
                    x: (currentX.float + (sin(currentAngle) * lineLen)),
                    y: (currentY.float - (cos(currentAngle) * lineLen)),
                ),
                lineThickness,
                branchColor,
            )
            currentX += (sin(currentAngle) * lineLen)
            currentY -= (cos(currentAngle) * lineLen)
        of '-': #turn right 25deg
            currentAngle += branchAngle
        of '+': #turn left 25deg
            currentAngle -= branchAngle
        of '[': #push pos and angle to stack
            stack.add((x: currentX, y: currentY, a: currentAngle))
        of ']': #pop pos and angle from stack
            drawCircle(Vector2(x: currentX, y: currentY), 2, leafColor)
            (currentX, currentY, currentAngle) = stack.pop()
        of 'X': #curve the line
            discard
        else:
            discard

func visualiseBush(axiom: string) =
    const
        lineLen = 5
        lineThickness = 2.0
        branchAngle = PI / 6
        branchColor = White
        leafColor = Green
    var
        stack: seq[tuple[x, y, a: float]]
        currentX = WIDTH / 2
        currentY = HEIGHT.float
        currentAngle = 0.0

    for c in axiom:
        case c
        of 'F': #forward
            drawLine(
                Vector2(x: currentX, y: currentY),
                Vector2(
                    x: (currentX.float + (sin(currentAngle) * lineLen)),
                    y: (currentY.float - (cos(currentAngle) * lineLen)),
                ),
                lineThickness,
                branchColor,
            )
            currentX += (sin(currentAngle) * lineLen)
            currentY -= (cos(currentAngle) * lineLen)
        of '-': #turn right 25deg
            currentAngle -= branchAngle
        of '+': #turn left 25deg
            currentAngle += branchAngle
        of '[': #push pos and angle to stack
            stack.add((x: currentX, y: currentY, a: currentAngle))
        of ']': #pop pos and angle from stack
            drawCircle(Vector2(x: currentX, y: currentY), 1, leafColor)
            (currentX, currentY, currentAngle) = stack.pop()
        else:
            discard

func visualiseCactus(axiom: string) =
    const
        lineLen = 1
        lineThickness = 25.0
        branchAngle = degToRad(25.0)
        branchColor = getColor(0x2E8B57ff)
        leafColor = getColor(0xD2B48C)
    var
        stack: seq[tuple[x, y, a: float]]
        currentX = WIDTH / 2
        currentY = HEIGHT.float
        currentAngle = 0.0

    for c in axiom:
        case c
        of 'F': #forward
            drawLine(
                Vector2(x: currentX, y: currentY),
                Vector2(
                    x: (currentX.float + (sin(currentAngle) * lineLen)),
                    y: (currentY.float - (cos(currentAngle) * lineLen)),
                ),
                lineThickness,
                branchColor,
            )
            currentX += (sin(currentAngle) * lineLen)
            currentY -= (cos(currentAngle) * lineLen)
        of '-': #turn right 25deg
            currentAngle -= branchAngle
        of '+': #turn left 25deg
            currentAngle += branchAngle
        of '[': #push pos and angle to stack
            stack.add((x: currentX, y: currentY, a: currentAngle))
        of ']': #pop pos and angle from stack
            drawCircle(Vector2(x: currentX, y: currentY), 2, leafColor)
            (currentX, currentY, currentAngle) = stack.pop()
        else:
            discard

proc main() =
    setConfigFlags(flags(Msaa4xHint))
    initWindow(WIDTH, HEIGHT, "CACTUS FRACTAL")
    setTargetFPS(60)

    const
        state1 = generation("X", fractalPlantRule, 6)
        state2 = generation("F", bushRule, 5)
        state3 = generation("X", cactusRule, 8)
    
    var i, framecount: int

    while (not windowShouldClose()):
        drawing:
            clearBackground(Black)

            # state1.visualiseFractalPlant()
            # state2.visualiseBush()
            # state3.visualiseCactus()

            let state4 = generation("X", cactusRule, i)
            state4.visualiseCactus()

            if framecount mod 60 == 1:
                inc i
            
            inc framecount




when isMainModule:
    main()
