using Assembly System.Drawing;
using Assembly System.Windows.Forms;

<#
    This script Renders a simple form. 
    - On Resize for the $Form the Controls will be resized and relocated accordingly.
    - On Clicking the Button "Get Random" A random line for the $Textbox will be selected. 

    Note: Don't confuse ClientSize and Size as the ClientSize is larger then the Form Size.
#>

#region Setup Form
$DefaultSize = [System.Drawing.Size]::new(500,550);
$Form = [System.Windows.Forms.Form]::new();
$Form.Size = $DefaultSize;
$Form.Text ="Auto Resizing Form"

function resizeControls(){
    $RefactorRaitoHeight = $Form.Size.Height / ($PreviousSize.Height);
    $RefactorSizeWidth  = $Form.Size.Width / ($PreviousSize.Width);
    forEach ($Control in $Form.Controls){
        $Control.Size =  [System.Drawing.Size]::new($($Control.Size.Width * $RefactorSizeWidth),$Control.Size.Height * $RefactorRaitoHeight);
        $Control.Location =  [System.Drawing.Point]::new($($Control.Location.X * $RefactorSizeWidth),$($Control.Location.Y * $RefactorRaitoHeight));
    }
    $Form.Refresh()
}

$Form.Add_ResizeEnd({resizeControls})
function beforeResize(){
    if (!PreviousSize){
        $PreviousSize = $DefaultSize;
    }
    $PreviousSize = $Form.Size;
}

$Form.Add_ResizeBegin({beforeResize});

#region Controls
$Label = [System.Windows.Forms.Label]::new();
$Label.Text = "One Option Per Line";
$Label.Size = [System.Drawing.Size]::new(150,20);
$Label.Location = [System.Drawing.Point]::new(25,25);

$Textbox = [System.Windows.Forms.TextBox]::new();
$Textbox.Multiline = $true; 
$Textbox.Size = [System.Drawing.Size]::new(350,350);
$Textbox.Location = [System.Drawing.Point]::new(25,50);

$Button = [System.Windows.Forms.Button]::new()
$Button.TabIndex = 0;
$Button.Size = [System.Drawing.Size]::new(100,20);
$Button.Name ="GetOption";
$Button.Text ="Get Random";
$Button.Location = [System.Drawing.Point]::new(25,400);
$Button.UseVisualStyleBackColor = $True

function getRandom() {
    $SplitString = $Textbox.Text.Split([Char[]]@("`n"), [System.StringSplitOptions]::RemoveEmptyEntries);
    if (!$SplitString){ return; }
    $Output.Text = Get-Random -InputObject $SplitString  
}

$Button.Add_Click({getRandom})

$Label2 = [System.Windows.Forms.Label]::new();
$Label2.Text = "Result";
$Label2.Size = [System.Drawing.Size]::new(150,20);
$Label2.Location = [System.Drawing.Point]::new(25,425);

$Output = [System.Windows.Forms.TextBox]::new();
$Output.Multiline = $false; 
$Output.Size = [System.Drawing.Size]::new(350,25);
$Output.Location = [System.Drawing.Point]::new(25,450);

#region Import Controls
$Form.Controls.Add($Label);
$Form.Controls.Add($Button);
$Form.Controls.Add($Textbox);
$Form.Controls.Add($Label2);
$Form.Controls.Add($Output);
#endregion
#endregion
#endregion

#Display and Bring Forth Form
$Form.ShowDialog();
$Form.BringToFront();
