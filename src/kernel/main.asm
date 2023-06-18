org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

; to jump to main
start:
  jmp main

; Prints a string to the screen
; Params:
;  - ds:si points to string
puts:
  ; save registers we will modify
  push si
  push ax

.loop:
  ; loads next character in al
  lodsb
  ; verify is next character is null          
  or al, al      
  jz .done

  ; call bios interrupt
  mov ah, 0x0e   
  int 0x10

  jmp .loop

.done:
  pop ax
  pop si
  ret

main:
  ; setup data segment
  ; can't write to ds/es directly
  mov ax, 0      
  mov ds, ax
  mov es, ax

  ; setup stack
  mov ss, ax
  ; stack grows downwards from where we loaded in memory
  mov sp, 0x7C00

  ; print message
  mov si, msg_hello
  call puts

  hlt

.halt:
  jmp .halt

msg_hello: db 'Hello World!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
