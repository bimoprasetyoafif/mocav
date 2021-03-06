Attribute VB_Name = "ModCeksum"

Option Explicit
Public Declare Sub CloseHandle Lib "kernel32" (ByVal hPass As Long)
Public Const OPEN_EXISTING As Long = 3
Public Const GENERIC_READ As Long = &H80000000
Public Const FILE_SHARE_READ As Long = &H1
Public Const PROV_RSA_FULL As Long = 1
Public Const CRYPT_VERIFYCONTEXT = &HF0000000
Public Const HP_HASHVAL As Long = 2
Public Const CALG_MD5 As Long = 32771
Public Const lMD5Length As Long = 16

Public Function GetMD5(sFile$) As String
    Dim hFile&, uBuffer() As Byte, lFileSize&, lBytesRead&, uMD5(lMD5Length) As Byte
    Dim I&, hCrypt&, hHash&, sMD5$


    hFile = CreateFile(sFile, GENERIC_READ, FILE_SHARE_READ, ByVal 0&, OPEN_EXISTING, ByVal 0&, ByVal 0&)
    
 
    If hFile > 0 Then
       
        lFileSize = GetFileSize(hFile, ByVal 0&)
    
        
        If lFileSize > 0 Then
            
            ReDim uBuffer(lFileSize - 1)
    

            If ReadFile(hFile, uBuffer(0), lFileSize, lBytesRead, ByVal 0&) <> 0 Then
                If lBytesRead <> lFileSize Then
                    ReDim Preserve uBuffer(lBytesRead - 1)
                End If
   DoEvents

                If CryptAcquireContext(hCrypt, vbNullString, vbNullString, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) <> 0 Then
                    If CryptCreateHash(hCrypt, CALG_MD5, 0&, 0&, hHash) <> 0 Then
                        If CryptHashData(hHash, uBuffer(0), lBytesRead, ByVal 0&) <> 0 Then
                            If CryptGetHashParam(hHash, HP_HASHVAL, uMD5(0), lMD5Length, 0) <> 0 Then
                                
                                For I = 0 To lMD5Length - 1
                                    sMD5 = sMD5 & (Right$("0" & Hex$(uMD5(I)), 2))
                                Next I
                            End If
                        End If


                        CryptDestroyHash hHash
                    End If
                    
                    
                    CryptReleaseContext hCrypt, 0
                End If
            End If
        End If
        
        
        CloseHandle hFile
    End If
    GetMD5 = UCase$(sMD5)
    Exit Function
End Function
Public Function Cocokan_Ceksum1(ceksum As String) As String
    Dim sampel As String
    Dim signa As String
    Dim virname As String
    Cocokan_Ceksum1 = ""
    Open App.path & "\database.db" For Input As #1
        Input #1, sampel
        signa = InStr(sampel, ceksum)
        If signa > 0 Then
            Cocokan_Ceksum1 = "Ada"
            GoTo selesai
        End If
    Close #1
selesai:
End Function

Public Function Cocokan_Ceksum_MD5(Ceksum2 As String) As String
Dim sampel2 As String
Dim signa2 As String
Dim virname2 As String
Cocokan_Ceksum_MD5 = ""
Open App.path & "\databese.db" For Input As #2
    Do
    Input #2, sampel2
    signa2 = Mid(sampel2, 1, InStr(1, sampel2, ":") - 1)
    virname2 = Mid(sampel2, InStr(1, sampel2, ":") + 1, Len(sampel2) - (Len(signa2) + 1))
    If signa2 = Ceksum2 Then
        Cocokan_Ceksum_MD5 = virname2
        Exit Do
    End If
    Loop Until sampel2 = "SampleVirus:SampleVirus"
Close #2
End Function

