Add-Type -AssemblyName System.Drawing

function Create-Screenshot1 {
    $bmp = New-Object System.Drawing.Bitmap 1080, 1920
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(248, 250, 252))
    $g.FillRectangle($bgBrush, 0, 0, 1080, 1920)

    # Top App Bar
    $headerBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, 58, 138))
    $g.FillRectangle($headerBrush, 0, 0, 1080, 240)

    $titleFont = New-Object System.Drawing.Font("Segoe UI", [float]42, [System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $g.DrawString("Circuit Point", $titleFont, $whiteBrush, [float]60, [float]110)

    $subFont = New-Object System.Drawing.Font("Segoe UI", [float]24, [System.Drawing.FontStyle]::Regular)
    $subBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(191, 219, 254))
    $g.DrawString("Electronics & Components Catalog", $subFont, $subBrush, [float]60, [float]175)

    # Search Bar
    $searchBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 255, 255))
    $g.FillRectangle($searchBrush, 60, 280, 960, 90)
    $searchBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(203, 213, 225), [float]3)
    $g.DrawRectangle($searchBorder, 60, 280, 960, 90)
    $searchTextFont = New-Object System.Drawing.Font("Segoe UI", [float]26, [System.Drawing.FontStyle]::Regular)
    $grayBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(148, 163, 184))
    $g.DrawString("Search electronic components...", $searchTextFont, $grayBrush, [float]100, [float]305)

    # Category Cards
    $cards = @(
        @{ Title = "Resistors"; Sub = "Fixed, SMD, Variable"; Color = [System.Drawing.Color]::FromArgb(239, 246, 255); Accent = [System.Drawing.Color]::FromArgb(37, 99, 235) },
        @{ Title = "Capacitors"; Sub = "Ceramic, Electrolytic, Tantalum"; Color = [System.Drawing.Color]::FromArgb(240, 253, 244); Accent = [System.Drawing.Color]::FromArgb(22, 163, 74) },
        @{ Title = "Transistors"; Sub = "BJT, MOSFET, IGBT, JFET"; Color = [System.Drawing.Color]::FromArgb(254, 242, 242); Accent = [System.Drawing.Color]::FromArgb(220, 38, 38) },
        @{ Title = "Diodes & LEDs"; Sub = "Schottky, Zener, RGB LEDs"; Color = [System.Drawing.Color]::FromArgb(254, 243, 199); Accent = [System.Drawing.Color]::FromArgb(217, 119, 6) },
        @{ Title = "Integrated Circuits"; Sub = "555 Timer, Op-Amps, Gates"; Color = [System.Drawing.Color]::FromArgb(245, 243, 255); Accent = [System.Drawing.Color]::FromArgb(124, 58, 237) },
        @{ Title = "Microcontrollers"; Sub = "Arduino, ESP32, STM32, PIC"; Color = [System.Drawing.Color]::FromArgb(236, 254, 255); Accent = [System.Drawing.Color]::FromArgb(8, 145, 178) }
    )

    $y = 410
    $cardFont = New-Object System.Drawing.Font("Segoe UI", [float]32, [System.Drawing.FontStyle]::Bold)
    $cardSubFont = New-Object System.Drawing.Font("Segoe UI", [float]22, [System.Drawing.FontStyle]::Regular)
    $darkBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, 41, 59))

    foreach ($card in $cards) {
        $cBrush = New-Object System.Drawing.SolidBrush $card.Color
        $g.FillRectangle($cBrush, 60, $y, 960, 180)
        
        $accentBrush = New-Object System.Drawing.SolidBrush $card.Accent
        $g.FillRectangle($accentBrush, 60, $y, 16, 180)

        $g.DrawString($card.Title, $cardFont, $darkBrush, [float]100, [float]($y + 35))
        $g.DrawString($card.Sub, $cardSubFont, $grayBrush, [float]100, [float]($y + 105))

        $y += 215
    }

    # Bottom Nav
    $navBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $g.FillRectangle($navBrush, 0, 1760, 1080, 160)
    $navBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(226, 232, 240), [float]3)
    $g.DrawLine($navBorder, 0, 1760, 1080, 1760)

    $navFont = New-Object System.Drawing.Font("Segoe UI", [float]24, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("Catalog", $navFont, $headerBrush, [float]180, [float]1820)
    $g.DrawString("Calculator", $navFont, $grayBrush, [float]500, [float]1820)
    $g.DrawString("Favourites", $navFont, $grayBrush, [float]820, [float]1820)

    $bmp.Save("c:\Users\welcome\Desktop\Circuit Point\playstore_assets\screenshot_1.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

function Create-Screenshot2 {
    $bmp = New-Object System.Drawing.Bitmap 1080, 1920
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # Background
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(248, 250, 252))
    $g.FillRectangle($bgBrush, 0, 0, 1080, 1920)

    # Top App Bar
    $headerBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, 58, 138))
    $g.FillRectangle($headerBrush, 0, 0, 1080, 240)

    $titleFont = New-Object System.Drawing.Font("Segoe UI", [float]42, [System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $g.DrawString("Resistor Color Code", $titleFont, $whiteBrush, [float]60, [float]110)

    $subFont = New-Object System.Drawing.Font("Segoe UI", [float]24, [System.Drawing.FontStyle]::Regular)
    $subBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(191, 219, 254))
    $g.DrawString("4-Band, 5-Band & 6-Band Decoder", $subFont, $subBrush, [float]60, [float]175)

    # Result Box
    $resBoxBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $g.FillRectangle($resBoxBrush, 60, 280, 960, 320)
    $resBoxPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(226, 232, 240), [float]3)
    $g.DrawRectangle($resBoxPen, 60, 280, 960, 320)

    $resLabelFont = New-Object System.Drawing.Font("Segoe UI", [float]24, [System.Drawing.FontStyle]::Regular)
    $grayBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(100, 116, 139))
    $g.DrawString("CALCULATED RESISTANCE", $resLabelFont, $grayBrush, [float]100, [float]320)

    $resValFont = New-Object System.Drawing.Font("Segoe UI", [float]68, [System.Drawing.FontStyle]::Bold)
    $blueBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(37, 99, 235))
    $g.DrawString("4.7 k Ohm +/- 5%", $resValFont, $blueBrush, [float]100, [float]380)

    # Resistor Graphic Simulation
    $bodyBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(224, 210, 180))
    $g.FillRectangle($bodyBrush, 160, 650, 760, 140)

    # Bands: Yellow, Violet, Red, Gold
    $b1 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(234, 179, 8))
    $g.FillRectangle($b1, 280, 650, 50, 140)
    $b2 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(147, 51, 234))
    $g.FillRectangle($b2, 420, 650, 50, 140)
    $b3 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(239, 68, 68))
    $g.FillRectangle($b3, 560, 650, 50, 140)
    $b4 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(217, 119, 6))
    $g.FillRectangle($b4, 750, 650, 50, 140)

    # Band selectors title
    $secFont = New-Object System.Drawing.Font("Segoe UI", [float]30, [System.Drawing.FontStyle]::Bold)
    $darkBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(30, 41, 59))
    $g.DrawString("Band Selection", $secFont, $darkBrush, [float]60, [float]850)

    # 4 Band Row Buttons
    $bandNames = @("Band 1: Yellow (4)", "Band 2: Violet (7)", "Multiplier: Red (x100)", "Tolerance: Gold (+/-5%)")
    $by = 920
    $bFont = New-Object System.Drawing.Font("Segoe UI", [float]26, [System.Drawing.FontStyle]::Bold)
    foreach ($bn in $bandNames) {
        $btnBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $g.FillRectangle($btnBrush, 60, $by, 960, 120)
        $g.DrawRectangle($resBoxPen, 60, $by, 960, 120)

        $g.DrawString($bn, $bFont, $darkBrush, [float]100, [float]($by + 40))
        $by += 150
    }

    # Bottom Nav
    $navBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $g.FillRectangle($navBrush, 0, 1760, 1080, 160)
    $navBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(226, 232, 240), [float]3)
    $g.DrawLine($navBorder, 0, 1760, 1080, 1760)

    $navFont = New-Object System.Drawing.Font("Segoe UI", [float]24, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("Catalog", $navFont, $grayBrush, [float]180, [float]1820)
    $g.DrawString("Calculator", $navFont, $headerBrush, [float]500, [float]1820)
    $g.DrawString("Favourites", $navFont, $grayBrush, [float]820, [float]1820)

    $bmp.Save("c:\Users\welcome\Desktop\Circuit Point\playstore_assets\screenshot_2.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

Create-Screenshot1
Create-Screenshot2
Write-Output "SCREENSHOTS_GENERATED_OK"
