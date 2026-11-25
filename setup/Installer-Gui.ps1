$ErrorActionPreference = 'Stop'

try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $catalogPath = Join-Path $PSScriptRoot 'windows\apps-windows.json'
    $catalog = Get-Content -LiteralPath $catalogPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if (-not $catalog.categories) { throw 'Le catalogue ne contient aucune application.' }

    $form = [System.Windows.Forms.Form]::new()
    $form.Text = 'Installation du PC · dotfiles'
    $form.Size = [System.Drawing.Size]::new(1020, 760)
    $form.MinimumSize = [System.Drawing.Size]::new(780, 590)
    $form.StartPosition = 'CenterScreen'
    $form.BackColor = [System.Drawing.Color]::FromArgb(246, 248, 251)
    $form.Font = [System.Drawing.Font]::new('Segoe UI', 9)
    $form.AutoScaleMode = 'Dpi'

    $layout = [System.Windows.Forms.TableLayoutPanel]::new()
    $layout.Dock = 'Fill'
    $layout.ColumnCount = 1
    $layout.RowCount = 5
    $null = $layout.RowStyles.Add([System.Windows.Forms.RowStyle]::new('Absolute', 105))
    $null = $layout.RowStyles.Add([System.Windows.Forms.RowStyle]::new('Absolute', 54))
    $null = $layout.RowStyles.Add([System.Windows.Forms.RowStyle]::new('Percent', 100))
    $null = $layout.RowStyles.Add([System.Windows.Forms.RowStyle]::new('Absolute', 175))
    $null = $layout.RowStyles.Add([System.Windows.Forms.RowStyle]::new('Absolute', 45))
    $form.Controls.Add($layout)

    $header = [System.Windows.Forms.Panel]::new()
    $header.Dock = 'Fill'
    $header.BackColor = [System.Drawing.Color]::White
    $layout.Controls.Add($header, 0, 0)

    $title = [System.Windows.Forms.Label]::new()
    $title.Text = 'Installer mon environnement'
    $title.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 18)
    $title.ForeColor = [System.Drawing.Color]::FromArgb(28, 41, 61)
    $title.SetBounds(20, 13, 720, 38)
    $title.Anchor = 'Top, Left, Right'
    $header.Controls.Add($title)

    $intro = [System.Windows.Forms.Label]::new()
    $intro.Text = 'Choisissez les applications et les étapes WSL, puis suivez leur installation en direct.'
    $intro.ForeColor = [System.Drawing.Color]::FromArgb(89, 101, 119)
    $intro.SetBounds(22, 55, 900, 22)
    $intro.Anchor = 'Top, Left, Right'
    $header.Controls.Add($intro)

    $manual = [System.Windows.Forms.LinkLabel]::new()
    $manual.Text = "Voir les $(@($catalog.manual).Count) installations manuelles"
    $manual.LinkColor = [System.Drawing.Color]::FromArgb(35, 100, 184)
    $manual.SetBounds(22, 79, 350, 22)
    $manual.add_LinkClicked({ Start-Process -FilePath (Join-Path $PSScriptRoot 'windows\catalogue-applications.md') })
    $header.Controls.Add($manual)

    $toolbar = [System.Windows.Forms.FlowLayoutPanel]::new()
    $toolbar.Dock = 'Fill'
    $toolbar.Padding = [System.Windows.Forms.Padding]::new(16, 9, 0, 0)
    $toolbar.BackColor = [System.Drawing.Color]::FromArgb(246, 248, 251)
    $layout.Controls.Add($toolbar, 0, 1)

    function New-Button([string]$text, [int]$width) {
        $button = [System.Windows.Forms.Button]::new()
        $button.Text = $text
        $button.Size = [System.Drawing.Size]::new($width, 32)
        $button.FlatStyle = 'Flat'
        $button.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(205, 214, 226)
        $button.BackColor = [System.Drawing.Color]::White
        $button.ForeColor = [System.Drawing.Color]::FromArgb(35, 52, 75)
        $button.Margin = [System.Windows.Forms.Padding]::new(4, 0, 4, 0)
        return $button
    }

    $startButton = New-Button 'Installer la sélection' 180
    $startButton.BackColor = [System.Drawing.Color]::FromArgb(35, 100, 184)
    $startButton.ForeColor = [System.Drawing.Color]::White
    $startButton.FlatAppearance.BorderSize = 0
    $allButton = New-Button 'Tout sélectionner' 130
    $noneButton = New-Button 'Tout désélectionner' 142
    $stopButton = New-Button "Arrêter après l'étape" 160
    $stopButton.Enabled = $false
    $null = $toolbar.Controls.Add($startButton)
    $null = $toolbar.Controls.Add($allButton)
    $null = $toolbar.Controls.Add($noneButton)
    $null = $toolbar.Controls.Add($stopButton)

    $list = [System.Windows.Forms.ListView]::new()
    $list.Dock = 'Fill'
    $list.Margin = [System.Windows.Forms.Padding]::new(20, 0, 20, 8)
    $list.View = 'Details'
    $list.CheckBoxes = $true
    $list.FullRowSelect = $true
    $list.HideSelection = $false
    $list.ShowGroups = $true
    $list.BackColor = [System.Drawing.Color]::White
    $null = $list.Columns.Add('Application ou étape', 330)
    $null = $list.Columns.Add('État', 150)
    $null = $list.Columns.Add('Détail', 460)
    $layout.Controls.Add($list, 0, 2)
    $list.add_Resize({ $list.Columns[2].Width = [Math]::Max(240, $list.ClientSize.Width - 500) })

    $script:rows = @{}
    function Add-Row([string]$id, [string]$name, [System.Windows.Forms.ListViewGroup]$group, [bool]$checked) {
        $row = [System.Windows.Forms.ListViewItem]::new($name)
        $row.Tag = $id
        $row.Group = $group
        $row.Checked = $checked
        $row.UseItemStyleForSubItems = $false
        $null = $row.SubItems.Add('En attente')
        $null = $row.SubItems.Add('')
        $null = $list.Items.Add($row)
        $script:rows[$id] = $row
    }

    foreach ($category in $catalog.categories) {
        $group = [System.Windows.Forms.ListViewGroup]::new([string]$category.name)
        $null = $list.Groups.Add($group)
        foreach ($app in $category.apps) {
            Add-Row "app:$($app.id)" ([string]$app.name) $group $true
        }
    }
    $wslGroup = [System.Windows.Forms.ListViewGroup]::new('WSL et outils défensifs · optionnel')
    $null = $list.Groups.Add($wslGroup)
    Add-Row 'wsl' 'WSL 2, Ubuntu et Kali' $wslGroup $false
    Add-Row 'tools' 'Outils défensifs Ubuntu et Kali' $wslGroup $false

    $logPanel = [System.Windows.Forms.Panel]::new()
    $logPanel.Dock = 'Fill'
    $logPanel.Margin = [System.Windows.Forms.Padding]::new(20, 0, 20, 0)
    $logPanel.BackColor = [System.Drawing.Color]::White
    $layout.Controls.Add($logPanel, 0, 3)
    $logTitle = [System.Windows.Forms.Label]::new()
    $logTitle.Text = "Journal d'installation"
    $logTitle.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 10)
    $logTitle.SetBounds(12, 7, 300, 23)
    $logPanel.Controls.Add($logTitle)
    $log = [System.Windows.Forms.RichTextBox]::new()
    $log.ReadOnly = $true
    $log.BorderStyle = 'None'
    $log.BackColor = [System.Drawing.Color]::White
    $log.ForeColor = [System.Drawing.Color]::FromArgb(55, 65, 80)
    $log.Font = [System.Drawing.Font]::new('Consolas', 9)
    $log.SetBounds(12, 32, 900, 135)
    $log.Anchor = 'Top, Bottom, Left, Right'
    $logPanel.Controls.Add($log)

    $footer = [System.Windows.Forms.Panel]::new()
    $footer.Dock = 'Fill'
    $footer.BackColor = [System.Drawing.Color]::FromArgb(246, 248, 251)
    $layout.Controls.Add($footer, 0, 4)
    $progress = [System.Windows.Forms.ProgressBar]::new()
    $progress.SetBounds(20, 12, 300, 18)
    $footer.Controls.Add($progress)
    $summary = [System.Windows.Forms.Label]::new()
    $summary.Text = 'Prêt · les étapes WSL sont facultatives et peuvent nécessiter un redémarrage.'
    $summary.ForeColor = [System.Drawing.Color]::FromArgb(75, 88, 107)
    $summary.SetBounds(336, 10, 650, 25)
    $summary.Anchor = 'Top, Left, Right'
    $footer.Controls.Add($summary)

    $script:running = $false
    $script:finished = $false
    $script:fatalMessage = ''
    $script:closeWhenDone = $false
    $script:reader = $null
    $script:process = $null
    $script:selected = @()
    $script:states = @{}
    $script:tempFiles = @()

    function Write-Log([string]$message) {
        if ([string]::IsNullOrWhiteSpace($message)) { return }
        $log.AppendText("$message`r`n")
        if ($log.Lines.Count -gt 700) {
            $log.Lines = @($log.Lines | Select-Object -Skip 150)
        }
        $log.SelectionStart = $log.TextLength
        $log.ScrollToCaret()
    }

    function Set-State([string]$id, [string]$state, [string]$message) {
        if (-not $script:rows.ContainsKey($id)) { return }
        $row = $script:rows[$id]
        $labels = @{ pending = 'En attente'; running = 'En cours'; done = 'Fait'; failed = 'Échoué'; restart = 'À reprendre'; skipped = 'Ignoré' }
        $colors = @{
            pending = [System.Drawing.Color]::FromArgb(102, 113, 127)
            running = [System.Drawing.Color]::FromArgb(30, 102, 195)
            done = [System.Drawing.Color]::FromArgb(24, 128, 78)
            failed = [System.Drawing.Color]::FromArgb(194, 55, 55)
            restart = [System.Drawing.Color]::FromArgb(184, 109, 23)
            skipped = [System.Drawing.Color]::FromArgb(102, 113, 127)
        }
        if (-not $labels.ContainsKey($state)) { return }
        $row.SubItems[1].Text = $labels[$state]
        $row.SubItems[1].ForeColor = $colors[$state]
        $row.SubItems[2].Text = $message
        $row.BackColor = if ($state -eq 'running') { [System.Drawing.Color]::FromArgb(235, 244, 255) } else { [System.Drawing.Color]::White }
        $script:states[$id] = $state

        $terminal = @('done', 'failed', 'restart', 'skipped')
        $completed = @($script:selected | Where-Object { $script:states[$_] -in $terminal }).Count
        $progress.Maximum = [Math]::Max(1, $script:selected.Count)
        $progress.Value = [Math]::Min($completed, $progress.Maximum)
        if ($script:running) { $summary.Text = "$completed / $($script:selected.Count) étapes traitées" }
    }

    $list.add_ItemCheck({
        param($sender, $eventArgs)
        if ($script:running) { $eventArgs.NewValue = $eventArgs.CurrentValue }
    })
    $allButton.add_Click({ foreach ($row in $list.Items) { $row.Checked = $true } })
    $noneButton.add_Click({ foreach ($row in $list.Items) { $row.Checked = $false } })

    $startButton.add_Click({
        $chosen = @($list.Items | Where-Object { $_.Checked } | ForEach-Object { [string]$_.Tag })
        if ($chosen.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show('Sélectionnez au moins une étape.', 'Installation', 'OK', 'Information') | Out-Null
            return
        }
        if ($chosen -contains 'wsl') {
            $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = [Security.Principal.WindowsPrincipal]::new($identity)
            if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                [System.Windows.Forms.MessageBox]::Show("Pour installer WSL, fermez cette fenêtre et lancez Installer.cmd en tant qu'administrateur.", 'Droits administrateur requis', 'OK', 'Warning') | Out-Null
                return
            }
        }

        $script:selected = $chosen
        $script:states = @{}
        $script:finished = $false
        $script:fatalMessage = ''
        $log.Clear()
        foreach ($row in $list.Items) {
            if ($row.Checked) { Set-State ([string]$row.Tag) 'pending' '' }
            else { Set-State ([string]$row.Tag) 'skipped' 'Non sélectionné' }
        }
        $runId = [guid]::NewGuid().ToString('N')
        $tempDir = [System.IO.Path]::GetTempPath()
        $selectionFile = Join-Path $tempDir "dotfiles-$runId-selection.json"
        $eventFile = Join-Path $tempDir "dotfiles-$runId-events.jsonl"
        $stopFile = Join-Path $tempDir "dotfiles-$runId-stop"
        $script:tempFiles = @($selectionFile, $eventFile, $stopFile)
        [System.IO.File]::WriteAllText($selectionFile, (@{ items = @($chosen | ForEach-Object { @{ id = $_ } }) } | ConvertTo-Json -Depth 4), [System.Text.UTF8Encoding]::new($false))

        try {
            $runner = Join-Path $PSScriptRoot 'Run-Installer.ps1'
            $info = [System.Diagnostics.ProcessStartInfo]::new()
            $info.FileName = (Get-Command powershell.exe).Source
            $info.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$runner`" -SelectionPath `"$selectionFile`" -EventPath `"$eventFile`" -StopPath `"$stopFile`""
            $info.UseShellExecute = $false
            $info.CreateNoWindow = $true
            $script:process = [System.Diagnostics.Process]::Start($info)
            $script:running = $true
            $startButton.Enabled = $false
            $allButton.Enabled = $false
            $noneButton.Enabled = $false
            $stopButton.Enabled = $true
            Write-Log 'Installation démarrée. Chaque étape est suivie séparément.'
        }
        catch {
            $script:running = $false
            foreach ($id in $chosen) { Set-State $id 'failed' 'Impossible de démarrer le processus' }
            Write-Log $_.Exception.Message
            $summary.Text = "Impossible de démarrer l'installation."
        }
    })

    $stopButton.add_Click({
        if (-not $script:running) { return }
        [System.IO.File]::WriteAllText($script:tempFiles[2], 'stop')
        $stopButton.Enabled = $false
        Write-Log "Arrêt demandé. L'étape en cours se termine avant l'arrêt."
    })

    $timer = [System.Windows.Forms.Timer]::new()
    $timer.Interval = 250
    $timer.add_Tick({
        if (-not $script:running) { return }
        if ($null -eq $script:reader -and [System.IO.File]::Exists($script:tempFiles[1])) {
            $fileStream = [System.IO.FileStream]::new($script:tempFiles[1], 'Open', 'Read', 'ReadWrite')
            $script:reader = [System.IO.StreamReader]::new($fileStream, [System.Text.Encoding]::UTF8)
        }
        if ($null -ne $script:reader) {
            while ($script:reader.Peek() -ge 0) {
                $line = $script:reader.ReadLine()
                try { $event = $line | ConvertFrom-Json } catch { continue }
                switch ($event.type) {
                    'log' { Write-Log "[$($event.id)] $($event.message)" }
                    'status' {
                        Set-State ([string]$event.id) ([string]$event.state) ([string]$event.message)
                        Write-Log "$($script:rows[[string]$event.id].Text) : $($event.message)"
                    }
                    'finished' { $script:finished = $true }
                    'fatal' {
                        $script:fatalMessage = [string]$event.message
                        Write-Log "Erreur : $($event.message)"
                    }
                }
            }
        }
        if ($script:process.HasExited) {
            $firstUnfinished = $true
            foreach ($id in $script:selected) {
                if ($script:states[$id] -eq 'running') { Set-State $id 'failed' 'Processus interrompu' }
                elseif ($script:states[$id] -eq 'pending') {
                    if ($firstUnfinished -and (-not $script:finished -or $script:fatalMessage)) {
                        Set-State $id 'failed' 'Processus interrompu — voir le journal'
                        $firstUnfinished = $false
                    }
                    else { Set-State $id 'skipped' 'Non exécuté' }
                }
            }
            $failed = @($script:selected | Where-Object { $script:states[$_] -eq 'failed' }).Count
            $done = @($script:selected | Where-Object { $script:states[$_] -eq 'done' }).Count
            $restart = @($script:selected | Where-Object { $script:states[$_] -eq 'restart' }).Count
            $summary.Text = "$done fait(s) · $failed échec(s) · $restart à reprendre"
            if (-not $script:finished) { Write-Log "Le processus s'est arrêté (code $($script:process.ExitCode))." }
            $script:running = $false
            $startButton.Enabled = $true
            $allButton.Enabled = $true
            $noneButton.Enabled = $true
            $stopButton.Enabled = $false
            if ($script:reader) { $script:reader.Dispose(); $script:reader = $null }
            $script:process.Dispose()
            $script:process = $null
            foreach ($path in $script:tempFiles) { Remove-Item -LiteralPath $path -ErrorAction SilentlyContinue }
            if ($script:closeWhenDone) { $form.Close() }
        }
    })
    $timer.Start()

    $form.add_FormClosing({
        param($sender, $eventArgs)
        if (-not $script:running) { return }
        $answer = [System.Windows.Forms.MessageBox]::Show(
            'Une installation est en cours. Arrêter après cette étape, puis fermer la fenêtre ?',
            'Installation en cours', 'YesNo', 'Question'
        )
        $eventArgs.Cancel = $true
        if ($answer -eq 'Yes') {
            [System.IO.File]::WriteAllText($script:tempFiles[2], 'stop')
            $script:closeWhenDone = $true
            $stopButton.Enabled = $false
            Write-Log "Fermeture demandée après l'étape en cours."
        }
    })

    [void]$form.ShowDialog()
    $timer.Dispose()
    $form.Dispose()
}
catch {
    [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, "Erreur de l'installateur", 'OK', 'Error') | Out-Null
    exit 1
}
