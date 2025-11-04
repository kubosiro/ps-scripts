Write-Host "Dang tu dong tim lop mang..." -ForegroundColor Yellow

# 1. Tim cau hinh mang dang hoat dong (cai co Default Gateway)
$config = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null } | Select-Object -First 1)

if (-not $config) {
    Write-Host "LOI: Khong tim thay card mang nao co Default Gateway." -ForegroundColor Red
    Write-Host "Cua so se tu dong dong sau 7 giay..."
    Start-Sleep -Seconds 7
    exit
}

# 2. Tao chuoi subnet (vi du: "10.20.30.40/24")
# Tailscale se tu dong hieu day la mang 10.20.30.0/24
$subnet = "$($config.IPv4Address.IPAddress)/$($config.IPv4Address.PrefixLength)"

Write-Host "Da tim thay IP/Prefix: $subnet" -ForegroundColor Cyan

# 3. Chay lenh Tailscale voi subnet vua tim duoc
Write-Host "Dang chay lenh 'tailscale set' voi lop mang $subnet..." -ForegroundColor Yellow
tailscale set --advertise-routes=$subnet --advertise-exit-node --exit-node-allow-lan-access

# 4. Kiem tra loi
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
