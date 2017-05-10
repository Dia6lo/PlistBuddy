class Plist
{
    [hashtable] $properties
    [string] $file
    [xml] $xml
    [System.Xml.XmlNode] $dict

    Plist($file)
    {
        $this.file = $file
        $this.xml = [xml](Get-Content $this.file)
        $this.dict = (Select-Xml -Xml $this.xml  -Xpath "/plist/dict").Node
        $this.properties = @{}
        $key = $null
        foreach ($node in $this.dict.ChildNodes)
        {
            if ($key -eq $null)
            {
                if ($node.Name -ne "key")
                {
                    Write-Error "Found non-key inside <dict>"
                    exit 1
                }
                $key = $node
            }
            else
            {
                $this.properties.Add($key, $node)
                $key = $null
            }
        }
    }

    Add([string] $entry, [string] $type, $value)
    {
        $entry = $entry.Replace(':', '/')
        Write-Host $entry
    }

    Save()
    {
        $this.dict.RemoveAll()
        foreach ($property in $this.properties.GetEnumerator() | Sort-Object { $_.Key.InnerText })
        {
            [void] $this.dict.AppendChild($property.Key)
            [void] $this.dict.AppendChild($property.Value)
        }
        $this.xml.Save($this.file)
    }
}

$plist = [Plist]::new("D:\Dev\PlistBuddy\Info — копия.plist")
$plist.Add(":CFBundleDocumentTypes:", "", "")
$plist.Save()

#Export-ModuleMember -Function *

