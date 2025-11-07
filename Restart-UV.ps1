# 1. Tắt UltraViewer
Get-Process -Name UltraViewer -ErrorAction SilentlyContinue | Stop-Process -Force

# 2. Delay 5 giây
Start-Sleep -Seconds 5

# 3. Chạy lại UltraViewer (lưu ý: UltraViewer.exe thường chạy với quyền user, nhưng nếu muốn đảm bảo quyền admin thì cần chạy qua Task Scheduler)
# Tìm đường dẫn chính xác của UltraViewer.exe
$UltraViewerPath = "C:\Program Files (x86)\UltraViewer\UltraViewer.exe" # Thay thế nếu khác
Start-Process -FilePath $UltraViewerPath
