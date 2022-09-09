   if (length(alltrim(Edit1.Text)) = 12) then //sistema novo
   begin
     //PVVVDDNNNNNN
     //Acha o primeiro dígito
     sTemp:=Modulo_11(Copy(Edit1.Text,7,6));
     if (Copy(Edit1.Text,5,1)=sTemp) and (Copy(Edit1.Text,6,1)= Modulo_11(IntToStr(Ord(Edit1.Text[1]))+Copy(Edit1.Text,2,4)+Copy(Edit1.Text,7,6))) then
       MessageDlg('N.Serial Aplicativo'+chr(10)+ ' C E R T O !', mtInformation,[mbOk], 0)
     else
       MessageDlg('N.Serial Aplicativo'+chr(10)+ ' E R R A D O !', mtERROR,[mbOk], 0);
   end;


   if (length(alltrim(Edit3.Text)) = 20) then //sistema novo
   begin
     //PPVVVDDSSSSSSNNSSSSS
     //Acha o primeiro dígito
     sTemp:=Modulo_11(Copy(Edit3.Text,8,13));
     if (Copy(Edit3.Text,6,1)=sTemp) and (Copy(Edit3.Text,7,1)= Modulo_11(IntToStr(Ord(Edit3.Text[1]))+IntToStr(Ord(Edit3.Text[2]))+Copy(Edit3.Text,3,4)+Copy(Edit3.Text,8,13))) then
      begin
       if Copy(Edit3.Text,2,1)='A' then
          MessageDlg('N.Serial Licença Aplicativo'+chr(10)+ ' C E R T O !', mtInformation,[mbOk], 0)
       else
          if Copy(Edit3.Text,2,1)='B' then
             MessageDlg('N.Serial Licença OS'+chr(10)+ ' C E R T O !', mtInformation,[mbOk], 0);
      end
     else
       MessageDlg('N.Serial licença'+chr(10)+ ' E R R A D O !', mtERROR,[mbOk], 0);
   end;