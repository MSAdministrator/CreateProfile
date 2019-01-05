---
external help file: CreateProfile-help.xml
Module Name: CreateProfile
online version:
schema: 2.0.0
---

# New-Profile

## SYNOPSIS
This function will create a new user profile

## SYNTAX

```
New-Profile [-UserName] <String> [-Password] <String> [<CommonParameters>]
```

## DESCRIPTION
This function will create a new local user and then map it to a user profile based on a SID. 
After that it will load the user profile.

## EXAMPLES

### EXAMPLE 1
```
New-Profile -UserName 'someusername' -password 'Password'
```

## PARAMETERS

### -UserName
This is the UserName of the User to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Password
This is the Password of the User to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Int32
## NOTES

## RELATED LINKS
