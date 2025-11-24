$OutputFile = "C:\Users\YOU\OpenVPN\tiktokfresh.ovpn"

$BaseConfig = @"
client
dev tun
proto udp
# remote nl1.vpnjantit.com 1194
# remote 195.123.216.159 1194
dhcp-option DNS 8.8.8.8
--data-ciphers AES-128-CBC
auth SHA1
resolv-retry infinite
nobind
persist-key
persist-tun
verb 3
auth-user-pass
route-delay 2
fast-io

route-nopull
"@

$Domains = @(
    "v16a.tiktokcdn.com",
    "p16-tiktokcdn-com.akamaized.net",
    "log.tiktokv.com",
    "ib.tiktokv.com",
    "api-h2.tiktokv.com",
    "v16m.tiktokcdn.com",
    "api.tiktokv.com",
    "v19.tiktokcdn.com",
    "mon.musical.ly",
    "api2-16-h2.musical.ly",
    "api2.musical.ly",
    "log2.musical.ly",
    "api2-21-h2.musical.ly",
    "api21-h2.tiktokv.com",
    "m.tiktok.com",
    "muscdn.com",
    "tiktokcdn.com",
    "tiktokcdn.com.c.worldfcdn.com",
    "tiktok.com",
    "www.tiktok.com",
    "tiktokcdn-com.akamaized.net"
)

$Routes = @()
foreach ($domain in $Domains) {
    try {
        $ips = Resolve-DnsName $domain -ErrorAction Stop | Where-Object { $_.Type -eq "A" } | Select-Object -ExpandProperty IPAddress
        foreach ($ip in $ips) {
            $Routes += "route $ip 255.255.255.255"
        }
    } catch {
        Write-Host "Fail to resolve $domain"
    }
}

$Routes = $Routes | Sort-Object -Unique

$FullConfig = $BaseConfig + "`r`n# TikTok routes`r`n" + ($Routes -join "`r`n")

Set-Content -Path $OutputFile -Value $FullConfig -Encoding ASCII

Write-Host "File generated: $OutputFile"

