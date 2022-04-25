d_seq segment para public
    filename db 'result.txt', 0
    buf db 1024 dup (?)
    handle dw 0 ; parametr for file index
    size dd 0
d_seq ends
 
s_seq segment para stack
db 256 dup (?)
s_seq ends
c_seq segment para public
assume cs:c_seq, ss:s_seq, ds:d_seq
start:  mov ax, d_seq
        mov ds, ax
    mov ax, ss
    mov ss, ax
 
    mov AH, 3dh ; give me file index
    mov AL, 0   ;0-read file
    mov DX, offset filename
    int 21h
    mov handle, AX
            
    mov     ax,     4202h    ;size of file
    mov     bx,   handle
    xor     cx,     cx
    mov     dx,     cx
    int     21h        
    mov     word ptr [size],ax
    mov     word ptr [size+2],dx
         
         
    mov     ax,     4200h      ;begin file
    mov     bx,  handle
    xor     cx,     cx
    mov     dx,     cx
   int     21h     
             
    mov AH, 3fh ; read something
    mov BX, handle          ;file index
    mov DX, offset buf ; where buf
    mov CX, size
    int 21h
 
    mov DI, offset buf 
    mov BX, size 
    mov byte ptr [DI+BX], '$' 
 
    mov AH, 9 ; ??????? ??????, ????????? ?? ?????
    mov DX, offset buf
    int 21h
         
    MOV AH, 0EH   ; ?????? ?????? ?? ???????? ????? ???????? (???????? ?????????), ????????? - ?????????? 10?    
   MOV AL, 0AH   ; ??????? ??????    
   INT 10H     
         

      

     
    mov AH, 3eh ; close file
    mov BX, handle
    int 21h 
       
       
       
    mov AH, 3dh ;for write something
    mov AL, 1
    mov DX, offset filename
    int 21h
    mov handle, AX  
       
 
     mov cx,size
       lea si,buf
       add si,cx
       
       m1:
       mov dl,[si]
       dec si
       dec cx 
         push cx
        mov ah,40h
        mov bx,handle
        mov dx,si  
        mov cx,1
        int 21h 
          pop cx
        mov ah,02h 
        mov dl,[si]
        int 21h 
         
       jnz m1     
    
    
    
    mov AH, 3eh ;close file
    mov BX, handle
    int 21h   
       
       
       
       
       
       
    mov ah, 4ch
    int 21h
c_seq ends
end start