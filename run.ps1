Write-Host "Dang chay lenh 'tailscale set'..." -ForegroundColor Yellow

tailscale set --advertise-routes=10.34.102.0/24 --advertise-exit-node --exit-node-allow-lan-access

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