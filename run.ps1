Write-Host "Dang tu dong tim lop mang..." -ForegroundColor Yellow

# 1. Tim cau hinh mang dang hoat dong
$config = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null } | Select-Object -First 1)

if (-not $config) {
    Write-Host "LOI: Khong tim thay card mang nao co Default Gateway." -ForegroundColor Red
    Start-Sleep -Seconds 7
    exit
}

# 2. Lay IP va Prefix
$ipString = $config.IPv4Address.IPAddress
$prefix = $config.IPv4Address.PrefixLength

# --- PHAN SUA LOI: TINH TOAN IP MANG TU IP MAY CON ---
# 2a. Chuyen IP string sang so nguyen (integer)
$ipBytes = [System.Net.IPAddress]::Parse($ipString).GetAddressBytes()
if ([System.BitConverter]::IsLittleEndian) { [System.Array]::Reverse($ipBytes) }
$ipInt = [System.BitConverter]::ToUInt32($ipBytes, 0)

# 2b. Tao mat na (mask) tu prefix
$maskInt = [System.Convert]::ToUInt32("0xFFFFFFFF", 16) -shl (32 - $prefix)

# 2c. Thuc hien phep AND de tim IP mang
$networkInt = $ipInt -band $maskInt

# 2d. Chuyen IP mang (integer) ve lai string
$networkBytes = [System.BitConverter]::GetBytes($networkInt)
if ([System.BitConverter]::IsLittleEndian) { [System.Array]::Reverse($networkBytes) }
$networkAddress = [System.Net.IPAddress]$networkBytes
# --- KET THUC SUA LOI ---

# 3. Tao chuoi subnet (vi du: "10.34.248.0/24")
$subnet = "$($networkAddress.ToString())/$prefix"

Write-Host "Da tim thay IP May: $ipString"
Write-Host "Da tinh toan IP Mang: $subnet" -ForegroundColor Cyan

# 4. Chay lenh Tailscale voi subnet chinh xac
Write-Host "Dang chay lenh 'tailscale set' voi lop mang $subnet..." -ForegroundColor Yellow
tailscale set --advertise-routes=$subnet --advertise-exit-node --exit-node-allow-lan-access

# 5. Kiem tra loi
$error.Clear()
tailscale status > $null

if ($error) {
    Write-Host "CO LOI! Lenh Tailscale khong thanh cong." -ForegroundColor Red
    Write-Host "Loi cu the: $($error[0])" -ForegroundColor Red
} else {
    Write-Host "THANH CONG! Da chay lenh 'tailscale set'." -ForegroundColor Green
    Write-Host "Buoc tiep theo: Vui long mo trang Admin Console (web) va F5 de PHE DUYET route."
}

Write-Host "Cua so se tu dong dong sau 7 giay..."
Start-Sleep -Seconds 7
