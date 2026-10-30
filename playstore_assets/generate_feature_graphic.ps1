Add-Type -AssemblyName System.Drawing

$width = 1024
$height = 500

$bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Gradient Background (Deep Navy to Tech Blue)
$rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
$colorStart = [System.Drawing.Color]::FromArgb(10, 18, 42)
$colorEnd = [System.Drawing.Color]::FromArgb(20, 48, 110)
$gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $colorStart, $colorEnd, 45.0)
$g.FillRectangle($gradientBrush, $rect)

# Draw High-Tech Circuit Board Traces & Glow Nodes
$circuitPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(35, 75, 160), 2.0)
$glowNodeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(96, 165, 250))
$goldNodeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(234, 179, 8))

# Angled PCB circuit paths
$paths = @(
    @(0, 100, 300, 100, 360, 160, 500, 160),
    @(0, 420, 200, 420, 260, 360, 600, 360),
    @(520, 40, 600, 120, 750, 120),
    @(700, 450, 800, 350, 1024, 350),
    @(850, 80, 950, 80, 1000, 130, 1024, 130)
)

foreach ($p in $paths) {
    for ($i = 0; $i -lt ($p.Length - 2); $i += 2) {
        $g.DrawLine($circuitPen, [int]$p[$i], [int]$p[$i+1], [int]$p[$i+2], [int]$p[$i+3])
    }
    $lastX = $p[$p.Length - 2]
    $lastY = $p[$p.Length - 1]
    $g.FillEllipse($glowNodeBrush, [int]($lastX - 4), [int]($lastY - 4), 8, 8)
}

$g.FillEllipse($goldNodeBrush, 300, 96, 8, 8)
$g.FillEllipse($goldNodeBrush, 200, 416, 8, 8)
$g.FillEllipse($goldNodeBrush, 600, 116, 8, 8)

# Glassmorphic Card on Right for Official Logo
$cardX = 630
$cardY = 50
$cardW = 350
$cardH = 400
$cardRect = New-Object System.Drawing.Rectangle($cardX, $cardY, $cardW, $cardH)

$cardBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
$g.FillRectangle($cardBg, $cardRect)

$cardBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(59, 130, 246), 4.0)
$g.DrawRectangle($cardBorder, $cardRect)

# Draw User Logo inside the card
$logoPath = "c:\Users\welcome\Desktop\Circuit Point\assets\images\logo.png"
if (Test-Path $logoPath) {
    $logoImg = [System.Drawing.Image]::FromFile($logoPath)
    $logoTargetRect = New-Object System.Drawing.Rectangle(($cardX + 20), ($cardY + 20), ($cardW - 40), ($cardH - 40))
    $g.DrawImage($logoImg, $logoTargetRect)
    $logoImg.Dispose()
}

# Left Side Typography
$appTitleFont = New-Object System.Drawing.Font("Segoe UI", 44.0, [System.Drawing.FontStyle]::Bold)
$titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString("CIRCUIT POINT", $appTitleFont, $titleBrush, 60.0, 70.0)

$taglineFont = New-Object System.Drawing.Font("Segoe UI", 18.0, [System.Drawing.FontStyle]::Bold)
$cyanBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 189, 248))
$g.DrawString("ELECTRONICS & HARDWARE REFERENCE", $taglineFont, $cyanBrush, 62.0, 145.0)

$descFont = New-Object System.Drawing.Font("Segoe UI", 15.0, [System.Drawing.FontStyle]::Regular)
$grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(203, 213, 225))
$g.DrawString("Your complete offline pocket guide for electrical calculations,", $descFont, $grayBrush, 62.0, 195.0)
$g.DrawString("resistor color codes, and electronic hardware specifications.", $descFont, $grayBrush, 62.0, 225.0)

# Feature Badges
$badges = @(
    @{ Text = "Power Calculator"; Color = [System.Drawing.Color]::FromArgb(30, 58, 138); Border = [System.Drawing.Color]::FromArgb(59, 130, 246) },
    @{ Text = "Resistor Decoder"; Color = [System.Drawing.Color]::FromArgb(19, 78, 74); Border = [System.Drawing.Color]::FromArgb(20, 184, 166) },
    @{ Text = "120+ Components"; Color = [System.Drawing.Color]::FromArgb(88, 28, 135); Border = [System.Drawing.Color]::FromArgb(168, 85, 247) }
)

$bx = 62
$by = 285
$badgeFont = New-Object System.Drawing.Font("Segoe UI", 12.0, [System.Drawing.FontStyle]::Bold)
$badgeTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

foreach ($b in $badges) {
    $bgB = New-Object System.Drawing.SolidBrush($b.Color)
    $g.FillRectangle($bgB, $bx, $by, 165, 46)

    $penB = New-Object System.Drawing.Pen($b.Border, 2.0)
    $g.DrawRectangle($penB, $bx, $by, 165, 46)

    $g.DrawString($b.Text, $badgeFont, $badgeTextBrush, [float]($bx + 14), [float]($by + 13))

    $bx += 178
}

# Bottom Guarantee
$botFont = New-Object System.Drawing.Font("Segoe UI", 14.0, [System.Drawing.FontStyle]::Bold)
$greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(74, 222, 128))
$g.DrawString("Works Offline  |  100% Free  |  Zero Data Collection", $botFont, $greenBrush, 62.0, 390.0)

# Save as 24-bit PNG & JPEG exactly 1024x500
$targetPng = "c:\Users\welcome\Desktop\Circuit Point\playstore_assets\feature_graphic_1024x500.png"
$targetJpg = "c:\Users\welcome\Desktop\Circuit Point\playstore_assets\feature_graphic_1024x500.jpg"

$bmp.Save($targetPng, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Save($targetJpg, [System.Drawing.Imaging.ImageFormat]::Jpeg)

$g.Dispose()
$bmp.Dispose()

Write-Output "SUCCESS: FEATURE_GRAPHIC_CREATED_1024x500"
