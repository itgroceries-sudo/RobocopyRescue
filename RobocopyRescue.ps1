# =========================================================
#  ROBOCOPY DATA RESCUE v1.2 (IT GROCERIES EDITION)
#  PowerShell WPF | Side-by-Side Console | Export to .CMD
# =========================================================

# [0] บังคับใช้ TLS 1.2 สำหรับการดาวน์โหลดผ่าน HTTPS
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# ---------------------------------------------------------
# [1] ตั้งค่าพื้นฐานและพจนานุกรมภาษา (EN / TH)
# ---------------------------------------------------------
$AppVersion  = "1.2 Build 24.11.2026"
$InstallDir  = "$env:LOCALAPPDATA\ITG_RobocopyRescue"
$TempScript  = "$env:TEMP\RobocopyRescue.ps1"
$GitHubRepo  = "https://github.com/itgroceries-sudo/RobocopyRescue"
$FacebookURL = "https://www.facebook.com/Adm1n1straTOE"
$SelfURL     = "https://raw.githubusercontent.com/itgroceries-sudo/RobocopyRescue/main/RobocopyRescue.ps1"
$IconURL     = "https://itgroceries.blogspot.com/favicon.ico"
$LogoURL     = "https://adamtheautomator.com/wp-content/uploads/2019/08/robocopy.png"
$TargetFile  = if ($ScriptPath) { $ScriptPath } elseif ($PSScriptRoot) { $PSCommandPath } else { $null }

# สร้างชื่อโฟลเดอร์สำรองตามวันที่ปัจจุบัน (BAK-DD-MM-YY)
$DateTag      = "BAK-" + [DateTime]::Now.ToString("dd-MM-yy", [System.Globalization.CultureInfo]::InvariantCulture)
$DefaultDrive = if (Test-Path "D:\") { "D:" } else { $env:SystemDrive }
$DefaultDest  = "$DefaultDrive\$DateTag"

# พจนานุกรมข้อความ 2 ภาษา
$LangDict = @{
    "EN" = @{
        "WinTitle"   = "Robocopy Data Rescue - IT Groceries Shop"
        "Title"      = "Robocopy Rescue"
        "Dev"        = "Developed by IT Groceries Shop™ ♥ ♥ ♥"
        "ScanLabel"  = "Detected Windows Users (Auto-Scan):"
        "BtnScan"    = "Scan"
        "SrcLabel"   = "Source Folder (Old Windows User Profile):"
        "DstLabel"   = "Destination Folder (Auto BAK-DD-MM-YY):"
        "Browse"     = "Browse"
        "SecFolders" = "Select Folders to Copy:"
        "AllProfile" = "Copy Entire Profile (Ignore checkboxes above)"
        "SecOptions" = "Robocopy Options:"
        "OptZB"      = "Bypass Permissions (/ZB - Backup Mode)"
        "OptAppData" = "Exclude AppData (/XD AppData)"
        "OptMT"      = "Fast Multi-Thread Copy (/MT:8)"
        "BtnNotepad" = "Admin Notepad"
        "BtnSaveCmd" = "Save As .cmd"
        "BtnStart"   = "Start Copy"
        "BtnExit"    = "EXIT"
        "Facebook"   = "Facebook"
        "GitHub"     = "GitHub"
        "About"      = "About"
        "LangLabel"  = "Language"
        "ErrNoSrc"   = "Source folder not found:"
        "WarnNoFld"  = "Please select at least one folder to copy."
        "SaveOK"     = "Saved offline .cmd script successfully:`n"
        "SaveErr"    = "Failed to save .cmd file:`n"
        "AboutMsg"   = "Robocopy Data Rescue`nVersion: $AppVersion`n`nBypass Windows permissions without Safe Mode.`nDeveloped by IT Groceries Shop"
    }
    "TH" = @{
        "WinTitle"   = "Robocopy Data Rescue - IT Groceries Shop"
        "Title"      = "กู้ข้อมูล Robocopy"
        "Dev"        = "พัฒนาโดย IT Groceries Shop™ ♥ ♥ ♥"
        "ScanLabel"  = "ตรวจพบ Windows & Users อัตโนมัติ:"
        "BtnScan"    = "สแกน"
        "SrcLabel"   = "โฟลเดอร์ต้นทาง (User ใน Windows เก่า):"
        "DstLabel"   = "โฟลเดอร์ปลายทาง (สร้าง BAK-DD-MM-YY อัตโนมัติ):"
        "Browse"     = "เลือก"
        "SecFolders" = "เลือกโฟลเดอร์ที่ต้องการดึงข้อมูล:"
        "AllProfile" = "ก๊อปปี้ทั้งโปรไฟล์ (ไม่สนใจตัวเลือกด้านบน)"
        "SecOptions" = "ตั้งค่าพารามิเตอร์ Robocopy:"
        "OptZB"      = "ทะลุสิทธิ์ไฟล์ที่ล็อก (/ZB - Backup Mode)"
        "OptAppData" = "ข้ามไฟล์ขยะ AppData (/XD AppData)"
        "OptMT"      = "ก๊อปปี้ความเร็วสูง (/MT:8)"
        "BtnNotepad" = "เปิด Notepad แอดมิน"
        "BtnSaveCmd" = "บันทึกเป็น .cmd"
        "BtnStart"   = "เริ่มก๊อปปี้"
        "BtnExit"    = "ออก"
        "Facebook"   = "Facebook"
        "GitHub"     = "GitHub"
        "About"      = "เกี่ยวกับ"
        "LangLabel"  = "ภาษา"
        "ErrNoSrc"   = "ไม่พบโฟลเดอร์ต้นทาง:"
        "WarnNoFld"  = "กรุณาเลือกโฟลเดอร์ที่ต้องการก๊อปปี้อย่างน้อย 1 รายการ"
        "SaveOK"     = "บันทึกไฟล์ .cmd สำหรับดับเบิลคลิกเรียบร้อยแล้ว:`n"
        "SaveErr"    = "เกิดข้อผิดพลาดในการบันทึกไฟล์:`n"
        "AboutMsg"   = "Robocopy Data Rescue`nเวอร์ชัน: $AppVersion`n`nเครื่องมือดึงข้อมูลทะลุสิทธิ์โดยไม่ต้องเข้า Safe Mode`nพัฒนาโดย IT Groceries Shop"
    }
}

# ตรวจสอบภาษาของระบบอัตโนมัติ
$SysRegion = (Get-Culture).TwoLetterISOLanguageName
$script:CurrentLang = if ($SysRegion -eq "th") { "TH" } else { "EN" }

# ---------------------------------------------------------
# [2] โหลด Win32 API สำหรับจัดการหน้าต่าง Console และไอคอน
# ---------------------------------------------------------
try {
    $User32 = Add-Type -MemberDefinition '
        [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
        [DllImport("user32.dll")] public static extern IntPtr LoadImage(IntPtr hinst, string lpszName, uint uType, int cxDesired, int cyDesired, uint fuLoad);
        [DllImport("user32.dll")] public static extern int SendMessage(IntPtr hWnd, int msg, int wParam, IntPtr lParam);
    ' -Name "User32" -Namespace Win32 -PassThru
    $ConsoleHandle = [Win32.User32]::GetConsoleWindow()
} catch {}

# ---------------------------------------------------------
# [3] ตรวจสอบสิทธิ์ Administrator และหน้าจอ Launcher
# ---------------------------------------------------------
$Identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
$Principal = [Security.Principal.WindowsPrincipal]$Identity
$IsAdmin   = $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    if ($ConsoleHandle) { [Win32.User32]::ShowWindow($ConsoleHandle, 5) | Out-Null }
    try { $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(90, 20) } catch {}

    $host.UI.RawUI.WindowTitle = "IT Groceries Launcher"
    $host.UI.RawUI.BackgroundColor = "DarkBlue"; $host.UI.RawUI.ForegroundColor = "White"; Clear-Host
    Write-Host "`n====================================================================================" -ForegroundColor DarkGray
    Write-Host "                     Robocopy Data Rescue [ Cloud Edition ]                         " -ForegroundColor Cyan -BackgroundColor DarkBlue
    Write-Host "                         Powered by IT Groceries Shop                               " -ForegroundColor DarkCyan -BackgroundColor DarkBlue
    Write-Host "====================================================================================" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "          This tool requires Administrator privileges for /ZB & Admin Notepad." -ForegroundColor Yellow
    Write-Host "          If you find this tool helpful, please Support Us on YouTube: " -NoNewline -ForegroundColor Gray
    Write-Host "IT Groceries" -ForegroundColor Green
    Write-Host ""
    Write-Host "        [ PERMISSION CHECK ] Press Enter, then click 'Yes' to continue: " -NoNewline -ForegroundColor White
    $null = Read-Host

    # ยกระดับสิทธิ์เป็น Admin (รองรับทั้งไฟล์ในเครื่องและรันผ่าน iex)
    try {
        if ($TargetFile -and (Test-Path $TargetFile)) {
            if ($TargetFile -match '\.(cmd|bat)$') {
                Start-Process -FilePath "$TargetFile" -Verb RunAs
            } else {
                Start-Process "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TargetFile`"" -Verb RunAs
            }
        } else {
            $WebClient = New-Object System.Net.WebClient
            $WebClient.Encoding = [System.Text.Encoding]::UTF8
            $ScriptContent = $WebClient.DownloadString($SelfURL)
            $Utf8WithBom = New-Object System.Text.UTF8Encoding $True
            [System.IO.File]::WriteAllText($TempScript, $ScriptContent, $Utf8WithBom)
            Start-Process "powershell" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$TempScript`"" -Verb RunAs
        }
    } catch {
        Write-Host "`n [ERROR] Failed to elevate: $_" -ForegroundColor Red
        Read-Host
    }
    exit
}

# ---------------------------------------------------------
# [4] เตรียมหน้าต่างคู่ Side-by-Side (ขนาดเท่ากัน 100%)
# ---------------------------------------------------------
Add-Type -AssemblyName PresentationFramework, System.Windows.Forms, System.Drawing
$Graphics = [System.Drawing.Graphics]::FromHwnd([IntPtr]::Zero)
$Scale    = $Graphics.DpiX / 96.0
$Graphics.Dispose()

# กำหนดขนาดมาตรฐาน (เท่ากันทั้ง Console และ UI)
$BaseW = 580; $BaseH = 860
$ConsoleW_Px = [int]($BaseW * $Scale)
$ConsoleH_Px = [int]($BaseH * $Scale)
$Scr = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea

$TotalWidth_Px = $ConsoleW_Px * 2
$StartX_Px = [int](($Scr.Width - $TotalWidth_Px) / 2)
$StartY_Px = [int](($Scr.Height - $ConsoleH_Px) / 2)

# คำนวณพิกัดฝั่งขวาสำหรับ WPF (หน่วย DIU)
$WindowX_WPF = ($StartX_Px + $ConsoleW_Px) / $Scale
$WindowY_WPF = $StartY_Px / $Scale

# ขยาย Buffer ป้องกันหน้าต่าง Console หดตัว แล้วจัดตำแหน่งฝั่งซ้าย
try { $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(120, 9999) } catch {}
if ($ConsoleHandle) {
    [Win32.User32]::ShowWindow($ConsoleHandle, 5) | Out-Null
    [Win32.User32]::SetWindowPos($ConsoleHandle, [IntPtr]0, $StartX_Px, $StartY_Px, $ConsoleW_Px, $ConsoleH_Px, 0x0040) | Out-Null
}

# ---------------------------------------------------------
# [5] ดาวน์โหลดและตั้งค่าไอคอน + โลโก้
# ---------------------------------------------------------
if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null }
$LocalIcon = "$InstallDir\ITG_Icon.ico"
$LocalLogo = "$InstallDir\RobocopyLogo.png"

$host.UI.RawUI.WindowTitle = "Robocopy Rescue - Log Console"
$host.UI.RawUI.BackgroundColor = "Black"; $host.UI.RawUI.ForegroundColor = "Gray"; Clear-Host

Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "   INITIALIZING ASSETS...                 " -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow

# ดาวน์โหลดทั้งไอคอน (สำหรับหัวหน้าต่าง/Console) และโลโก้ PNG (สำหรับโชว์ใน UI)
$Assets = @{
    "ITG_Icon.ico"     = $IconURL
    "RobocopyLogo.png" = $LogoURL
}

foreach ($file in $Assets.Keys) {
    $destPath = Join-Path $InstallDir $file
    if (-not (Test-Path $destPath) -or (Get-Item $destPath).Length -lt 100) {
        try {
            $wc = New-Object Net.WebClient
            $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
            $wc.DownloadFile($Assets[$file], $destPath)
            Write-Host " [DOWNLOAD] OK: $file" -ForegroundColor Green
        } catch {
            Write-Host " [ERROR]    Fail to download $file" -ForegroundColor Red
        }
    } else {
        Write-Host " [CACHE]    OK: $file" -ForegroundColor DarkGray
    }
}

# เปลี่ยนไอคอนฝั่ง Console
if ((Test-Path $LocalIcon) -and $ConsoleHandle) {
    $hIcon = [Win32.User32]::LoadImage([IntPtr]::Zero, $LocalIcon, 1, 0, 0, 0x10)
    if ($hIcon) {
        [Win32.User32]::SendMessage($ConsoleHandle, 0x80, [IntPtr]0, $hIcon) | Out-Null
        [Win32.User32]::SendMessage($ConsoleHandle, 0x80, [IntPtr]1, $hIcon) | Out-Null
    }
}

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "   Robocopy Rescue (v$AppVersion)         " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host " [INIT] Launching GUI..." -ForegroundColor Yellow

# ฟังก์ชันเสียงประกอบ
function Play-Sound($Type) {
    try {
        switch ($Type) {
            "Click" { [System.Media.SystemSounds]::Beep.Play() }
            "Tick"  { [System.Console]::Beep(2000, 20) }
            "Warn"  { [System.Media.SystemSounds]::Hand.Play() }
            "Done"  { [System.Media.SystemSounds]::Asterisk.Play() }
        }
    } catch {}
}

# ---------------------------------------------------------
# [6] ออกแบบ XAML UI (เก็บปุ่ม Close/Minimize ครบ + โทนมืด)
# ---------------------------------------------------------
try {
    [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Robocopy Data Rescue - IT Groceries Shop"
        Height="$BaseH" Width="$BaseW"
        WindowStartupLocation="Manual"
        ResizeMode="CanMinimize"
        WindowStyle="SingleBorderWindow"
        Background="#181818">
    <Window.Resources>
        <!-- สไตล์สวิตช์เปิด-ปิดสีฟ้า -->
        <Style x:Key="BlueSwitch" TargetType="{x:Type CheckBox}">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type CheckBox}">
                        <Border x:Name="T" Width="44" Height="24" Background="#3E3E3E" CornerRadius="12" Cursor="Hand">
                            <Border x:Name="D" Width="20" Height="20" Background="White" CornerRadius="10" HorizontalAlignment="Left" Margin="2,0,0,0">
                                <Border.RenderTransform><TranslateTransform x:Name="Tr" X="0"/></Border.RenderTransform>
                            </Border>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsChecked" Value="True">
                                <Trigger.EnterActions>
                                    <BeginStoryboard><Storyboard>
                                        <DoubleAnimation Storyboard.TargetName="Tr" Storyboard.TargetProperty="X" To="20" Duration="0:0:0.15"/>
                                        <ColorAnimation Storyboard.TargetName="T" Storyboard.TargetProperty="Background.Color" To="#2196F3" Duration="0:0:0.15"/>
                                    </Storyboard></BeginStoryboard>
                                </Trigger.EnterActions>
                                <Trigger.ExitActions>
                                    <BeginStoryboard><Storyboard>
                                        <DoubleAnimation Storyboard.TargetName="Tr" Storyboard.TargetProperty="X" To="0" Duration="0:0:0.15"/>
                                        <ColorAnimation Storyboard.TargetName="T" Storyboard.TargetProperty="Background.Color" To="#3E3E3E" Duration="0:0:0.15"/>
                                    </Storyboard></BeginStoryboard>
                                </Trigger.ExitActions>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- สไตล์ปุ่มโค้งมน -->
        <Style x:Key="Btn" TargetType="Button">
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="20">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" TextElement.FontWeight="Bold"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Opacity" Value="0.85"/></Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- สไตล์ปุ่มแถบล่าง -->
        <Style x:Key="LabeledBtn" TargetType="Button">
            <Setter Property="Background" Value="#333333"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Height" Value="42"/>
            <Setter Property="Margin" Value="0,0,6,0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="b" Background="{TemplateBinding Background}" CornerRadius="6" Padding="10,0,10,0">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" TextElement.FontWeight="Bold" TextElement.FontSize="13"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="b" Property="Opacity" Value="0.85"/></Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- สไตล์ ComboBox โทนมืด -->
        <ControlTemplate x:Key="ComboBoxToggleButton" TargetType="ToggleButton">
            <Border x:Name="Border" CornerRadius="4" Background="#252526" BorderBrush="#0078D7" BorderThickness="1">
                <Path x:Name="Arrow" Fill="#2196F3" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0" Data="M 0 0 L 4 4 L 8 0 Z"/>
            </Border>
        </ControlTemplate>
        <Style TargetType="{x:Type ComboBox}">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBox">
                        <Grid>
                            <ToggleButton Name="ToggleButton" Template="{StaticResource ComboBoxToggleButton}" Focusable="false" IsChecked="{Binding Path=IsDropDownOpen,Mode=TwoWay,RelativeSource={RelativeSource TemplatedParent}}" ClickMode="Press"/>
                            <ContentPresenter Name="ContentSite" IsHitTestVisible="False" Content="{TemplateBinding SelectionBoxItem}" Margin="8,4,25,4" VerticalAlignment="Center" HorizontalAlignment="Left"/>
                            <Popup Name="Popup" Placement="Bottom" IsOpen="{TemplateBinding IsDropDownOpen}" AllowsTransparency="True" Focusable="False" PopupAnimation="Slide">
                                <Grid Name="DropDown" SnapsToDevicePixels="True" MinWidth="{TemplateBinding ActualWidth}" MaxHeight="200">
                                    <Border x:Name="DropDownBorder" Background="#252526" BorderThickness="1" BorderBrush="#2196F3"/>
                                    <ScrollViewer Margin="2" SnapsToDevicePixels="True">
                                        <StackPanel IsItemsHost="True" KeyboardNavigation.DirectionalNavigation="Contained"/>
                                    </ScrollViewer>
                                </Grid>
                            </Popup>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- สไตล์ช่องกรอก Path -->
        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#252526"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderBrush" Value="#444444"/>
            <Setter Property="Padding" Value="8,6"/>
            <Setter Property="FontSize" Value="13"/>
        </Style>
    </Window.Resources>

    <Grid Margin="20,15,20,15">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- ส่วนหัว: โลโก้ (ซูมครอบคำว่า Robocopy) + ชื่อโปรแกรม -->
        <Grid Grid.Row="0" Margin="0,0,0,12">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <Border Grid.Column="0" Width="105" Height="58" CornerRadius="8" ClipToBounds="True" Background="#000000" VerticalAlignment="Center">
                <Image x:Name="Logo" Stretch="Uniform" RenderOptions.BitmapScalingMode="HighQuality" RenderTransformOrigin="0.5,0.5">
                    <Image.RenderTransform>
                        <ScaleTransform ScaleX="2.2" ScaleY="2.2"/>
                    </Image.RenderTransform>
                </Image>
            </Border>

            <StackPanel Grid.Column="1" VerticalAlignment="Center" Margin="15,0,0,0">
                <TextBlock x:Name="T_Title" Text="Robocopy Rescue" Foreground="White" FontSize="26" FontWeight="Bold">
                    <TextBlock.Effect><DropShadowEffect Color="#2196F3" BlurRadius="12" Opacity="0.7"/></TextBlock.Effect>
                </TextBlock>
                <TextBlock x:Name="T_Dev" Text="Developed by IT Groceries Shop™ ♥ ♥ ♥" Foreground="#FF4444" FontSize="13" FontWeight="Bold" Margin="2,3,0,0"/>
            </StackPanel>
        </Grid>

        <!-- ส่วนสแกน Windows/Users และเลือก Path ต้นทาง / ปลายทาง -->
        <Border Grid.Row="1" Background="#1E1E1E" CornerRadius="6" Padding="12" Margin="0,0,0,10" BorderBrush="#333333" BorderThickness="1">
            <StackPanel>
                <!-- แถวสแกน Windows & Users อัตโนมัติ -->
                <TextBlock x:Name="T_ScanLabel" Text="Detected Windows Users (Auto-Scan):" Foreground="#00FFFF" FontSize="12" FontWeight="Bold" Margin="0,0,0,4"/>
                <Grid Margin="0,0,0,8">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <ComboBox x:Name="cmbUsers" Grid.Column="0" Height="32" Cursor="Hand"/>
                    <Button x:Name="btnScan" Content="Scan" Grid.Column="1" Width="75" Margin="8,0,0,0" Background="#2E7D32" Foreground="White" BorderThickness="0" Cursor="Hand" FontWeight="Bold"/>
                </Grid>

                <!-- แถวโฟลเดอร์ต้นทาง -->
                <TextBlock x:Name="T_SrcLabel" Text="Source Folder (Old Windows User Profile):" Foreground="#CCCCCC" FontSize="12" Margin="0,0,0,4"/>
                <Grid Margin="0,0,0,8">
                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBox x:Name="txtSource" Text="E:\Users\User" Grid.Column="0"/>
                    <Button x:Name="btnBrowseSrc" Content="Browse" Grid.Column="1" Width="75" Margin="8,0,0,0" Background="#0078D7" Foreground="White" BorderThickness="0" Cursor="Hand" FontWeight="Bold"/>
                </Grid>

                <!-- แถวโฟลเดอร์ปลายทาง (BAK-DD-MM-YY) -->
                <TextBlock x:Name="T_DstLabel" Text="Destination Folder (Auto BAK-DD-MM-YY):" Foreground="#CCCCCC" FontSize="12" Margin="0,0,0,4"/>
                <Grid>
                    <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                    <TextBox x:Name="txtDest" Text="$DefaultDest" Grid.Column="0"/>
                    <Button x:Name="btnBrowseDst" Content="Browse" Grid.Column="1" Width="75" Margin="8,0,0,0" Background="#0078D7" Foreground="White" BorderThickness="0" Cursor="Hand" FontWeight="Bold"/>
                </Grid>
            </StackPanel>
        </Border>

        <!-- ส่วนรายการโฟลเดอร์และออปชัน -->
        <Border Grid.Row="2" Background="#1E1E1E" CornerRadius="6" Padding="12" BorderBrush="#333333" BorderThickness="1">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
                <StackPanel>
                    <TextBlock x:Name="T_SecFolders" Text="Select Folders to Copy:" Foreground="#00FFFF" FontSize="13" FontWeight="Bold" Margin="0,0,0,6"/>

                    <!-- การ์ดรายการโฟลเดอร์ -->
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock Text="Desktop" Foreground="White" FontSize="14" VerticalAlignment="Center"/><CheckBox x:Name="chkDesktop" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="True"/></Grid>
                    </Border>
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock Text="Documents" Foreground="White" FontSize="14" VerticalAlignment="Center"/><CheckBox x:Name="chkDocuments" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="True"/></Grid>
                    </Border>
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock Text="Downloads" Foreground="White" FontSize="14" VerticalAlignment="Center"/><CheckBox x:Name="chkDownloads" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="True"/></Grid>
                    </Border>
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock Text="Pictures" Foreground="White" FontSize="14" VerticalAlignment="Center"/><CheckBox x:Name="chkPictures" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="True"/></Grid>
                    </Border>
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock Text="Videos" Foreground="White" FontSize="14" VerticalAlignment="Center"/><CheckBox x:Name="chkVideos" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="False"/></Grid>
                    </Border>
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock Text="Music" Foreground="White" FontSize="14" VerticalAlignment="Center"/><CheckBox x:Name="chkMusic" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="False"/></Grid>
                    </Border>
                    <Border Background="#2A2418" CornerRadius="5" Padding="10,6" Margin="0,0,0,10" BorderBrush="#665500" BorderThickness="1">
                        <Grid><TextBlock x:Name="T_AllProfile" Text="Copy Entire Profile (Ignore checkboxes above)" Foreground="#FFD700" FontSize="13" FontWeight="SemiBold" VerticalAlignment="Center"/><CheckBox x:Name="chkAllProfile" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="False"/></Grid>
                    </Border>

                    <TextBlock x:Name="T_SecOptions" Text="Robocopy Options:" Foreground="#00FFFF" FontSize="13" FontWeight="Bold" Margin="0,2,0,6"/>

                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock x:Name="T_OptZB" Text="Bypass Permissions (/ZB - Backup Mode)" Foreground="White" FontSize="13" VerticalAlignment="Center"/><CheckBox x:Name="chkZB" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="True"/></Grid>
                    </Border>
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,5">
                        <Grid><TextBlock x:Name="T_OptAppData" Text="Exclude AppData (/XD AppData)" Foreground="White" FontSize="13" VerticalAlignment="Center"/><CheckBox x:Name="chkExcludeAppData" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="True"/></Grid>
                    </Border>
                    <Border Background="#252526" CornerRadius="5" Padding="10,6" Margin="0,0,0,2">
                        <Grid><TextBlock x:Name="T_OptMT" Text="Fast Multi-Thread Copy (/MT:8)" Foreground="White" FontSize="13" VerticalAlignment="Center"/><CheckBox x:Name="chkMultiThread" Style="{StaticResource BlueSwitch}" HorizontalAlignment="Right" IsChecked="True"/></Grid>
                    </Border>
                </StackPanel>
            </ScrollViewer>
        </Border>

        <!-- แถบปุ่มดำเนินการหลัก: Notepad Admin | Save As .cmd (สีส้ม) | Start Copy -->
        <Grid Grid.Row="3" Margin="0,12,0,10">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <Button x:Name="btnNotepad" Content="Admin Notepad" Grid.Column="0" Width="165" Height="44" Background="#1565C0" Foreground="White" Style="{StaticResource Btn}" FontSize="14"/>
            <Button x:Name="btnSaveCmd" Content="Save As .cmd" Grid.Column="1" Width="145" Height="44" Background="#FF9800" Foreground="#000000" Style="{StaticResource Btn}" FontSize="14" HorizontalAlignment="Center"/>
            <Button x:Name="btnApply" Content="Start Copy" Grid.Column="2" Width="165" Height="44" Background="#2E7D32" Foreground="White" Style="{StaticResource Btn}" FontSize="15"/>
        </Grid>

        <!-- แถบปุ่มด้านล่าง: Social, About, Language, EXIT -->
        <Grid Grid.Row="4">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <StackPanel Orientation="Horizontal" Grid.Column="0">
                <Button x:Name="BF" Style="{StaticResource LabeledBtn}">
                    <StackPanel Orientation="Horizontal">
                        <TextBlock Text="f" Foreground="#1877F2" FontSize="22" FontWeight="Bold" Margin="0,-3,6,0" VerticalAlignment="Center"/>
                        <TextBlock x:Name="T_FB" Text="Facebook" Foreground="White" VerticalAlignment="Center"/>
                    </StackPanel>
                </Button>
                <Button x:Name="BG" Style="{StaticResource LabeledBtn}">
                    <StackPanel Orientation="Horizontal">
                        <Viewbox Width="18" Height="18" Margin="0,0,6,0"><Path Fill="White" Data="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/></Viewbox>
                        <TextBlock x:Name="T_Git" Text="GitHub" Foreground="White" VerticalAlignment="Center"/>
                    </StackPanel>
                </Button>
                <Button x:Name="BAbt" Style="{StaticResource LabeledBtn}" Background="#546E7A">
                    <StackPanel Orientation="Horizontal">
                        <Viewbox Width="18" Height="18" Margin="0,0,6,0"><Path Fill="White" Data="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 17h-2v-2h2v2zm2.07-7.75l-.9.92C13.45 12.9 13 13.5 13 15h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H8c0-2.21 1.79-4 4-4s4 1.79 4 4c0 .88-.36 1.68-.93 2.25z"/></Viewbox>
                        <TextBlock x:Name="T_Abt" Text="About" Foreground="White" VerticalAlignment="Center"/>
                    </StackPanel>
                </Button>
                <Button x:Name="BLang" Style="{StaticResource LabeledBtn}" Background="#444444">
                    <StackPanel Orientation="Horizontal">
                        <Viewbox Width="18" Height="18" Margin="0,0,6,0"><Path Fill="White" Data="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/></Viewbox>
                        <TextBlock x:Name="T_Lang" Text="Language" Foreground="White" VerticalAlignment="Center"/>
                    </StackPanel>
                </Button>
            </StackPanel>
            <Button x:Name="BC" Content="EXIT" Grid.Column="2" Width="85" Height="42" Background="#D32F2F" Foreground="White" Style="{StaticResource Btn}" FontSize="14"/>
        </Grid>
    </Grid>
</Window>
"@

    # โหลดหน้าต่างและจัดวางตำแหน่งด้านขวาคู่กับ Console
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $Window = [Windows.Markup.XamlReader]::Load($reader)
    try { $Window.Left = $WindowX_WPF; $Window.Top = $WindowY_WPF } catch {}
    if (Test-Path $LocalIcon) { $Window.Icon = $LocalIcon }
    if (Test-Path $LocalLogo) { $Window.FindName("Logo").Source = $LocalLogo }

    # เชื่อมต่อ Control
    $cmbUsers          = $Window.FindName("cmbUsers")
    $btnScan           = $Window.FindName("btnScan")
    $txtSource         = $Window.FindName("txtSource")
    $txtDest           = $Window.FindName("txtDest")
    $btnBrowseSrc      = $Window.FindName("btnBrowseSrc")
    $btnBrowseDst      = $Window.FindName("btnBrowseDst")
    $chkDesktop        = $Window.FindName("chkDesktop")
    $chkDocuments      = $Window.FindName("chkDocuments")
    $chkDownloads      = $Window.FindName("chkDownloads")
    $chkPictures       = $Window.FindName("chkPictures")
    $chkVideos         = $Window.FindName("chkVideos")
    $chkMusic          = $Window.FindName("chkMusic")
    $chkAllProfile     = $Window.FindName("chkAllProfile")
    $chkZB             = $Window.FindName("chkZB")
    $chkExcludeAppData = $Window.FindName("chkExcludeAppData")
    $chkMultiThread    = $Window.FindName("chkMultiThread")
    $btnNotepad        = $Window.FindName("btnNotepad")
    $btnSaveCmd        = $Window.FindName("btnSaveCmd")
    $btnApply          = $Window.FindName("btnApply")
    $BF                = $Window.FindName("BF")
    $BG                = $Window.FindName("BG")
    $BAbt              = $Window.FindName("BAbt")
    $BLang             = $Window.FindName("BLang")
    $BC                = $Window.FindName("BC")

    # ฟังก์ชันสแกนหา Windows และ Users จากทุกไดรฟ์ (เรียงไดรฟ์ที่ไม่ใช่ C: ขึ้นก่อน)
    function Scan-WindowsUsers {
        Write-Host "`n [SCAN] Scanning drives for Windows & Users..." -ForegroundColor Cyan
        $cmbUsers.Items.Clear()
        $ExcludeNames = @("Public", "Default", "Default User", "All Users", "defaultuser0")
        $FoundExternal = @()
        $FoundCurrent  = @()

        $Drives = [System.IO.DriveInfo]::GetDrives() | Where-Object { $_.IsReady -and ($_.DriveType -eq 'Fixed' -or $_.DriveType -eq 'Removable') }
        foreach ($drv in $Drives) {
            $root = $drv.RootDirectory.FullName.TrimEnd('\')
            $winPath   = "$root\Windows"
            $usersPath = "$root\Users"

            if ((Test-Path $winPath) -and (Test-Path $usersPath)) {
                Write-Host " [FOUND] Windows detected on $root" -ForegroundColor Green
                $userDirs = Get-ChildItem -Path $usersPath -Directory -ErrorAction SilentlyContinue | Where-Object { $ExcludeNames -notcontains $_.Name }
                foreach ($u in $userDirs) {
                    Write-Host "   -> User: $($u.FullName)" -ForegroundColor Gray
                    if ($root -ieq $env:SystemDrive) {
                        $FoundCurrent += $u.FullName
                    } else {
                        $FoundExternal += $u.FullName
                    }
                }
            }
        }

        $AllFound = $FoundExternal + $FoundCurrent
        if ($AllFound.Count -gt 0) {
            foreach ($path in $AllFound) {
                $item = New-Object System.Windows.Controls.ComboBoxItem
                $item.Content = $path
                $item.Foreground = "White"
                $item.Background = "#252526"
                $cmbUsers.Items.Add($item) | Out-Null
            }
            $cmbUsers.SelectedIndex = 0
            $txtSource.Text = $AllFound[0]
        } else {
            Write-Host " [WARN] No Windows User profiles found." -ForegroundColor Yellow
        }
    }

    # ฟังก์ชันอัปเดตข้อความตามภาษาที่เลือก
    function Update-Language {
        $D = $LangDict[$script:CurrentLang]
        $Window.Title = $D["WinTitle"]
        $Window.FindName("T_Title").Text      = $D["Title"]
        $Window.FindName("T_Dev").Text        = $D["Dev"]
        $Window.FindName("T_ScanLabel").Text  = $D["ScanLabel"]
        $btnScan.Content                      = $D["BtnScan"]
        $Window.FindName("T_SrcLabel").Text   = $D["SrcLabel"]
        $Window.FindName("T_DstLabel").Text   = $D["DstLabel"]
        $btnBrowseSrc.Content                 = $D["Browse"]
        $btnBrowseDst.Content                 = $D["Browse"]
        $Window.FindName("T_SecFolders").Text = $D["SecFolders"]
        $Window.FindName("T_AllProfile").Text = $D["AllProfile"]
        $Window.FindName("T_SecOptions").Text = $D["SecOptions"]
        $Window.FindName("T_OptZB").Text      = $D["OptZB"]
        $Window.FindName("T_OptAppData").Text = $D["OptAppData"]
        $Window.FindName("T_OptMT").Text      = $D["OptMT"]
        $btnNotepad.Content                   = $D["BtnNotepad"]
        $btnSaveCmd.Content                   = $D["BtnSaveCmd"]
        $btnApply.Content                     = $D["BtnStart"]
        $BC.Content                           = $D["BtnExit"]
        $Window.FindName("T_FB").Text         = $D["Facebook"]
        $Window.FindName("T_Git").Text        = $D["GitHub"]
        $Window.FindName("T_Abt").Text        = $D["About"]
        $Window.FindName("T_Lang").Text       = $D["LangLabel"]
    }

    # ฟังก์ชันเลือกโฟลเดอร์
    function Select-FolderDialog($initialPath) {
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        if (Test-Path $initialPath) { $dialog.SelectedPath = $initialPath }
        if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { return $dialog.SelectedPath }
        return $null
    }

    # เริ่มต้นอัปเดตภาษาและสแกนหา Windows/Users ทันที
    Update-Language
    Scan-WindowsUsers

    # อีเวนต์เมื่อเลือก User จาก Dropdown
    $cmbUsers.Add_SelectionChanged({
        if ($cmbUsers.SelectedItem) {
            $txtSource.Text = $cmbUsers.SelectedItem.Content
            Write-Host " [SELECT] Source set to: $($txtSource.Text)" -ForegroundColor Cyan
        }
    })

    # อีเวนต์ปุ่ม Scan
    $btnScan.Add_Click({ Play-Sound "Click"; Scan-WindowsUsers })

    # อีเวนต์ปุ่ม Browse ต้นทาง
    $btnBrowseSrc.Add_Click({
        Play-Sound "Click"
        $p = Select-FolderDialog $txtSource.Text
        if ($p) { $txtSource.Text = $p; Write-Host " [PATH] Source set to: $p" -ForegroundColor Cyan }
    })

    # อีเวนต์ปุ่ม Browse ปลายทาง (ต่อท้ายด้วย BAK-DD-MM-YY อัตโนมัติ)
    $btnBrowseDst.Add_Click({
        Play-Sound "Click"
        $p = Select-FolderDialog $txtDest.Text
        if ($p) {
            $cleanP = $p.TrimEnd('\')
            if ($cleanP -notmatch "BAK-\d{2}-\d{2}-\d{2}$") {
                $cleanP = "$cleanP\$DateTag"
            }
            $txtDest.Text = $cleanP
            Write-Host " [PATH] Target set to: $cleanP" -ForegroundColor Cyan
        }
    })

    # อีเวนต์ปุ่ม Social / About / Language
    $BF.Add_Click({ Play-Sound "Click"; Start-Process $FacebookURL })
    $BG.Add_Click({ Play-Sound "Click"; Start-Process $GitHubRepo })
    $BAbt.Add_Click({ Play-Sound "Click"; [System.Windows.MessageBox]::Show($LangDict[$script:CurrentLang]["AboutMsg"], "About", "OK", "Information") | Out-Null })
    $BLang.Add_Click({
        $script:CurrentLang = if ($script:CurrentLang -eq "EN") { "TH" } else { "EN" }
        Play-Sound "Click"
        Update-Language
        Write-Host " [LANG] Switched to: $script:CurrentLang" -ForegroundColor DarkCyan
    })

    # อีเวนต์ปุ่มวิธีที่ 1: เปิด Notepad สิทธิ์ Admin
    $btnNotepad.Add_Click({
        Play-Sound "Click"
        Write-Host " [ACTION] Launching Notepad as Administrator (Use Ctrl+O -> All Files)..." -ForegroundColor Cyan
        Start-Process notepad.exe -Verb RunAs
    })

    # อีเวนต์ปุ่ม Save As .cmd (สร้างไฟล์ Hybrid .cmd สำหรับดับเบิลคลิกใช้งานออฟไลน์)
    $btnSaveCmd.Add_Click({
        Play-Sound "Click"
        $D = $LangDict[$script:CurrentLang]
        $sfd = New-Object System.Windows.Forms.SaveFileDialog
        $sfd.Title = "Save Offline Hybrid Script (.cmd)"
        $sfd.Filter = "Windows Command Script (*.cmd)|*.cmd"
        $sfd.FileName = "RobocopyRescue.cmd"
        $sfd.InitialDirectory = [Environment]::GetFolderPath("Desktop")

        if ($sfd.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            try {
                Write-Host " [SAVE] Preparing offline .cmd script..." -ForegroundColor Yellow
                $rawCode = ""
                if ($TargetFile -and (Test-Path $TargetFile)) {
                    $rawCode = [System.IO.File]::ReadAllText($TargetFile, [System.Text.Encoding]::UTF8)
                } else {
                    $wc = New-Object System.Net.WebClient
                    $wc.Encoding = [System.Text.Encoding]::UTF8
                    $rawCode = $wc.DownloadString($SelfURL)
                }

                # ลบ BOM เดิมออกเพื่อไม่ให้ CMD แจ้ง Error บรรทัดแรก
                $rawCode = $rawCode.TrimStart([char]0xFEFF)

                # เติมหัว Hybrid Batch พร้อม -Encoding UTF8 อัตโนมัติ (กรณีต้นฉบับไม่มีหัว Batch)
                $hybridHeader = "<# : hybrid batch + powershell script`r`n@echo off`r`nmode con: cols=85 lines=20`r`npowershell -noprofile -c `"`$param='%*';`$ScriptPath='%~f0';iex((Get-Content('%~f0') -Raw -Encoding UTF8))`"`r`nexit /b`r`n#>`r`n`r`n"
                if ($rawCode -notmatch "^<#\s*:\s*hybrid") {
                    $rawCode = $hybridHeader + $rawCode
                }

                # บันทึกเป็น UTF-8 (ไม่มี BOM) เพื่อให้ CMD รันลื่นและ PowerShell อ่านภาษาไทยได้สมบูรณ์
                $utf8NoBom = New-Object System.Text.UTF8Encoding $False
                [System.IO.File]::WriteAllText($sfd.FileName, $rawCode, $utf8NoBom)

                Write-Host " [SAVE] Saved to: $($sfd.FileName)" -ForegroundColor Green
                Play-Sound "Done"
                [System.Windows.MessageBox]::Show("$($D['SaveOK'])$($sfd.FileName)", "Success", "OK", "Information") | Out-Null
            } catch {
                Play-Sound "Warn"
                Write-Host " [ERROR] Save failed: $_" -ForegroundColor Red
                [System.Windows.MessageBox]::Show("$($D['SaveErr'])$_", "Error", "OK", "Error") | Out-Null
            }
        }
    })

    # อีเวนต์ปุ่มวิธีที่ 2: สั่งรัน Robocopy
    $btnApply.Add_Click({
        Play-Sound "Click"
        $D   = $LangDict[$script:CurrentLang]
        $src = $txtSource.Text.Trim().TrimEnd('\')
        $dst = $txtDest.Text.Trim().TrimEnd('\')

        if (-not (Test-Path $src)) {
            Play-Sound "Warn"
            Write-Host " [ERROR] Source not found: $src" -ForegroundColor Red
            [System.Windows.MessageBox]::Show("$($D['ErrNoSrc']) $src", "Error", "OK", "Error") | Out-Null
            return
        }

        $flags = "/E /COPY:DAT /R:1 /W:1"
        if ($chkZB.IsChecked)             { $flags += " /ZB" }
        if ($chkExcludeAppData.IsChecked) { $flags += " /XD AppData" }
        if ($chkMultiThread.IsChecked)    { $flags += " /MT:8" }

        $commands = @()
        if ($chkAllProfile.IsChecked) {
            $commands += "robocopy `"$src`" `"$dst`" $flags"
        } else {
            $folders = @()
            if ($chkDesktop.IsChecked)   { $folders += "Desktop" }
            if ($chkDocuments.IsChecked) { $folders += "Documents" }
            if ($chkDownloads.IsChecked) { $folders += "Downloads" }
            if ($chkPictures.IsChecked)  { $folders += "Pictures" }
            if ($chkVideos.IsChecked)    { $folders += "Videos" }
            if ($chkMusic.IsChecked)     { $folders += "Music" }

            if ($folders.Count -eq 0) {
                Play-Sound "Warn"
                [System.Windows.MessageBox]::Show($D["WarnNoFld"], "Warning", "OK", "Warning") | Out-Null
                return
            }

            foreach ($f in $folders) {
                $commands += "robocopy `"$src\$f`" `"$dst\$f`" $flags"
            }
        }

        $fullCmd = ($commands -join " & ") + " & echo. & echo [DONE] Backup process finished! & pause"
        Write-Host "`n [RUN] Executing Robocopy in elevated CMD..." -ForegroundColor Green
        Write-Host " [CMD] $fullCmd" -ForegroundColor DarkGray
        Start-Process cmd.exe -ArgumentList "/c $fullCmd" -Verb RunAs
        Play-Sound "Done"
    })

    # อีเวนต์ปุ่ม EXIT (และเคลียร์ไฟล์ชั่วคราวเมื่อปิดหน้าต่าง)
    $CleanupAndExit = {
        Write-Host "`n [EXIT] Clean & Bye !!" -ForegroundColor Cyan
        if ($PSCommandPath -eq $TempScript) {
            Start-Process "cmd.exe" -ArgumentList "/c timeout /t 2 >nul & del `"$TempScript`"" -WindowStyle Hidden
        }
        [Environment]::Exit(0)
    }
    $BC.Add_Click({ Play-Sound "Click"; $Window.Close() })
    $Window.Add_Closed($CleanupAndExit)

    $Window.ShowDialog() | Out-Null

} catch {
    Write-Host "`n [FATAL ERROR] The application crashed:" -ForegroundColor Red
    Write-Host " $_" -ForegroundColor Red
    Write-Host "`n Press Enter to exit..." -ForegroundColor Gray
    Read-Host
}
