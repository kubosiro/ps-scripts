Write-Host "Dang huy bo (tat) chuc nang quang ba Subnet Route..." -ForegroundColor Yellow

# De trong --advertise-routes= se xoa tat ca cac route
tailscale set --advertise-routes= --advertise-exit-node --exit-node-allow-lan-access

$error.Clear()
tailscale status > $null

if ($error) {
    Write-Host "CO LOI! Lenh Tailscale khong thanh cong." -ForegroundColor Red
    Write-Host "Loi cu the: $($error[0])" -ForegroundColor Red
} else {
    Write-Host "THANH CONG! Da tat chuc nang Subnet Route." -ForegroundColor Green
    Write-Host "May van con la mot Exit Node."
}

Write-Host "Cua so se tu dong dong sau 7 giay..."
Start-Sleep -Seconds 7
