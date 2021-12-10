INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

.data
	bufferSize EQU 5000
	buffer DB bufferSize dup (?), 0Ah, 0
	byteRead DB ?
	fileToRead DB 50 dup(?), 0
	msg DB "This program will open the file you want and print the input from the file into the console",0Ah,0
	inputMsg DB "Please input the file you want to open (input .txt at the end of the file)",0Ah,0
	editPrompt DB "Do you want to edit this file?", 0Ah , 0
	editCaption DB "File Edit",0Ah , 0
	exitMsg DB "Thank you for using this program", 0Ah , 0
	editTemp DB 5000 dup (?), 0Ah , 0 
	strLen DD ?
	startEdit equ OFFSET buffer + strLen
	temp DD ?
	fileHandle DD ?
	testss DB "okay.txt",0

.code
main PROC
	mov edx, OFFSET msg
	call WriteString
	input:	
		mov edx, OFFSET inputMsg
		call WriteString
		mov edx, OFFSET fileToRead
		mov ecx, SIZEOF fileToRead
		call ReadString
	print:
		call OpenInputFile
		mov fileHandle, eax
		mov edx, OFFSET buffer
		mov ecx, bufferSize
		call ReadFromFile
		mov eax, fileHandle
		call CloseFile
		call ClrScr
		mov edx, OFFSET buffer
		call WriteString
		mov eax, 3000
		call Delay
		mov edx, OFFSET editprompt
		mov ebx, OFFSET editcaption
		call MsgBoxAsk
		cmp eax, 6
		jz edit
		call ClrScr
		mov edx, OFFSET ExitMsg
		call WriteString
		INVOKE ExitProcess, 0
	edit:
		call ClrScr
		mov edx, OFFSET editTemp
		mov ecx, SIZEOF editTemp
		call ReadString
		mov ecx, eax
		xor eax, eax
		mov edx, OFFSET buffer
		call StrLength 
		mov strLen, eax  
		mov esi, 0
		mov edi, strLen
		xor eax, eax
	append:
		mov al, [editTemp+ esi]
		mov temp, esi
		mov esi, strLen
		add esi, temp
		mov [buffer + esi], al
		mov esi, temp
		add esi, 1
		loop append
	output:
		call ClrScr
		mov edx, OFFSET fileToRead
		call CreateOutputFile
		mov edx, OFFSET buffer
		mov ecx, bufferSize
		call WriteToFile

	

main ENDP
END main